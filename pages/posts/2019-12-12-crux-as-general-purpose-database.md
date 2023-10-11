%{
  title: "XTDB as General-Purpose Database",
  description: "XTDB is an innovative database in the Clojure world. What follows is an experience report.",
  keywords: ["XTDB", "Crux", "Clojure", "database", "Datomic"],
  archive: true
}
---

[XTDB](https://xtdb.com) is open source, [*bitemporal*](https://en.wikipedia.org/wiki/Bitemporal_Modeling), highly scalable and built on solid foundations with [Kafka](https://kafka.apache.org/) and [RocksDB](https://rocksdb.org/) as default storage. It is very flexible and provides low-level building blocks to allow you to build exactly the database you need for your use-case.

I believe that having time as first class concept in your database should be the default. It is much easier to have the concept of time built-in from the beginning and only build specialized solutions for the parts where performance becomes a problem. Nowadays computers are powerful enough that in most cases performance is not the issue and the focus should be on simplicity and correctness first.

By coincidence I started a toy project, [letsdo.events](https://github.com/jorinvo/letsdo.events), to write more Clojure in the spring of this year. Just after I started, XTDB announced its public beta. Naturally I had to give it a try.

Since letsdo.events is mostly a toy project to play with different ideas. I took this opportunity to test XTDB for a normal, standard application. The goal was to see if XTDB hides the overhead of bitemporal storage well enough to make it viable as a default approach even when it is not an initial requirement of the application.

To start out I chose to only persist using RocksDB which allows to pack the whole system in a single *.jar* file and deploy it as a single process. Once the storage needs to scale, it would be trivial to switch to Kafka as storage backend. Since all the data is simply a log of transactions and documents, replaying them into a new storage would be straight forward.

Because of the flexibility XTDB gives you, it does not necessarily have all the tools you would expect from a database built-in. Surely there will be more tools and patterns in the ecosystem of XTDB once it has been around for a bit longer. But for now, here are a few things I built in [the application's database layer](https://github.com/jorinvo/letsdo.events/blob/master/src/lde/core/db.clj):

## Single Transactor

*Update: By now XTDB officially supports [transaction functions](https://docs.xtdb.com/language-reference/datalog-transactions/#transaction-functions) which allow you to achieve the same things you would use a single transactor for, but in a distributed and potentially more performant way.*

Enforcing constraints such as uniqueness is built into many databases. The simplest way to achieve this outside the database is to only allow a single write at a time.
Reads can still happen in parallel.

I created a `tx` helper which is used for all writes to the database:

```
(let [ctx (init {:config config})]
  (tx ctx (if (exists-by-attribute :user/email mail)
              :email-taken
              (create! {:user/email mail} ctx)))
  (close ctx))
```

## `:id` key

XTDB expects the ID it uses internally under the namespaced key `:crux.db/id`. This is a good pattern to not conflict with any domain-specific data. However in my business logic I always ended up wanting to use this same ID without coupling the business logic to XTDB.

So in letsdo.events all database functions convert the ID to `:id` transparently using these helpers:

```
(defn- crux->id [x] (rename-keys x {:crux.db/id :id}))
(defn- id->crux [x] (rename-keys x {:id :crux.db/id}))
```

## Working with document time

It is totally fine in XTDB to have normal `:created` and `:updated` as part of your documents. And in most cases that is probably a good idea for performance. But you don't need to have these timestamps since XTDB also tracks time in its history.

It might not always be a good idea to do this but I created a helper which takes a list of document IDs and returns the documents with additional `:created` and `:updated` keys:

```
(defn list-by-ids-with-timestamps [{:keys [::crux]} ids]
  (let [db (crux/db crux)]
    (->> ids
         (map #(let [h (crux/history crux %)]
                 (assoc (crux->id (crux/entity db %))
                        :created (-> h last :crux.db/valid-time)
                        :updated (-> h first :crux.db/valid-time)))))))
```


## Common database operations

The primitives XTDB provides for transactions and the datalog language for querying are simple yet powerful. Still, for an application to interact with the database I prefer to hide the details of the how the database works behind plain functions.

The [`lde.core.db`](https://github.com/jorinvo/letsdo.events/blob/master/src/lde/core/db.clj) namespace contains helpers for operations such as create, update, delete, list, get by id, get by attribute, count, exists.

However, the database layer still allows to do plain datalog queries which is very useful for join-like queries likes this one:

```
(defn get-organizer-names-by-event-id [ctx event-id]
  (->> (db/q ctx {:find ['?name]
                  :where '[[o :organizer/event e]
                           [o :organizer/user u]
                           [u :user/name ?name]]
                  :args [{'e event-id}]})
       (map first)
       not-empty))
```


## Global queries

Another great development feature of XTDB has been the ability to easily query across all your data.

In relational databases this would involve writing out all tables and joining them together in a gigantic query, but with XTDB and datalog there is no strict separation between data types.

You can easily query attributes across all documents which makes it very simple in development to understand the data in your system:

```
; All data in db
(->> (crux/q (crux/db (:lde.core.db/crux @ctx))
             {:find '[id]
              :where '[[id :crux.db/id _]]})
      (map first)
      (map #(crux/entity (crux/db (:lde.core.db/crux @ctx)) %)))
```

This is very handy for all sorts of global statistics:

```
; All attributes in db
(->> (crux/q (crux/db (:lde.core.db/crux @ctx))
             {:find '[id]
              :where '[[id :crux.db/id _]]})
      (map first)
      (map #(crux/entity (crux/db (:lde.core.db/crux @ctx)) %))
      (mapcat keys)
      set
      sort)
```


## Wrap up

It has been fun to work with XTDB for this project.

Getting started with a new application with a schemaless database also made things easier. I can imagine that for mature projects it would be helpful to enforce more constraints on write in the database or via [clojure.spec](https://clojure.org/guides/spec).

So far I haven't tested out XTDB at scale but the existing examples look very promising.

The pluggable architecture is one of biggest strong points of XTDB and makes it very flexible to switch to a different storage backend or index implementation.

The biggest challenge will be to integrate with the world people are familiar with since Clojure, EDN and datalog are still far from mainstream at this point. But with the HTTP API, integrations such as Kafka Connect, potential plans for an SQL-like frontend and detailed documentation, the future looks bright.

I do believe having time built-in from the start is a huge advantage for any new project and will become the norm in the future.

-----

_Update May 2022: Crux has been renamed to XTDB and I updated the article accordingly_
