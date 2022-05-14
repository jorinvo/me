---
title: "XTDB Healthcare Typescript Demo"
date: 2021-01-24T14:50:06+01:00
---

XTDB is a great fit for healthcare applications. Let's see how to use it in JavaScript land.<!--more-->


## Why XTDB for Healthcare?

[XTDB](https://xtdb.com) is an unbundled, bitemporal document store.

Let's unwrap this.

[![XTDB logo](https://xtdb.com/images/logo.svg)](https://xtdb.com)

The term *Unbundled* comes from the [origin of Apache Kafka](https://martin.kleppmann.com/2015/03/04/turning-the-database-inside-out.html). Most databases use an event log internally for sending state to different parts of the system reliably. We now know that this pattern is also pretty useful in the bigger picture. It's especially useful when you have to build systems with lots of integrations. Not surprisingly a complex industry such as healthcare is made up of many sub-systems that all need to exchange data. HL7 or FHIR anyone? Having a solid foundation to build on helps a great deal with getting data synchronisation right.

With a *temporal* data store you store all of history. You will always know about all changes to the data.
With a *bitemporal* database you store history, plus you can fix errors in historic values. And you still have a record of all changes.
Turns out that both, fixing errors and keeping a record of all changes, are pretty handy when working with critical patient data.
Regulations, audit requirements and demands for data integrity basically force you to model your system this way.

XTDB makes sure you know about every change to data, but at the same time you have the ability to erase data completely. [Evict](https://docs.xtdb.com/language-reference/datalog-transactions/#evict) makes sure you can be GDPR-compliant.

Lastly, XTDB stores *documents*. You do not define schemas and relationships upfront. You can write any document to the database.
Why is that helpful? Healthcare is made up of many complex sub-systems generating different data. Traditionally rather slow-moving, these days health tech is also picking up a faster pace of change.
You need a way to deal with incomplete data, changing requirements and questions you didn't know will come up in the future.
Modeling constraints becomes so complex that a single, consistent model is not enough. You need more flexibility in asserting facts about your data.
Let the data store take care of storing data. Model your application logic in your application.

To sum it up,

**XTDB is designed for complex systems with strict data integrity needs.**

**Healthcare is such a system.**


## Why JavaScript? Why Typescript?

The short answer is, *they are popular*.

JavaScript makes software development accessible to so many people. They shouldn't miss out on XTDB.

TypeScript has also become more popular lately. It can help making a code base more robust and enables great IDE tools. This is especially helpful as projects become bigger.

If we can provide a clearly defined interface for XTDB in TypeScript, its usage becomes straight forward.


## Demo Time

I created a demo for people to see how such a setup could look like.

You can find it [on Github](https://github.com/jorinvo/crux-typescript-healthcare-demo/).

The example runs a minimal XTDB setup via [Docker and Compose](https://docs.docker.com/compose/).

```clojure
{:crux/tx-log {:kv-store {:crux/module crux.rocksdb/->kv-store
                          :db-dir "tx-log"}}
 :crux/document-store {:kv-store {:crux/module crux.rocksdb/->kv-store
                                  :db-dir "docs"}}
 :crux/index-store {:kv-store {:crux/module crux.rocksdb/->kv-store
                               :db-dir "indexes"
                               :metrics {:crux/module crux.rocksdb.metrics/->metrics
                                         :instance "index-store"}}}
 :crux.http-server/server {:port 3000}
 :crux.metrics/metrics {}
 :crux.metrics.prometheus/http-exporter {:jvm-metrics? true}}
 ```

The XTDB configuration stores data in RocksDB. XTDB provides an HTTP API which we can use from JS land. The setup also demos JMX and Prometheus metrics to watch what's going on in the database. You can find all the details in the README.

The Node.js application talks to XTDB via EDN over HTTP. I implemented a TypeScript interface on top of that. It's documented [here](https://github.com/jorinvo/crux-typescript-healthcare-demo#api-overview) and you can easily see [how it is done](https://github.com/jorinvo/crux-typescript-healthcare-demo/blob/master/client/src/crux/index.ts). We use [edn-data](https://github.com/jorinvo/edn-data) to talk to XTDB.


## Generate Data

Part of the demo is a tool that [generates](https://github.com/jorinvo/crux-typescript-healthcare-demo#data-generator) some healthcare-inspired data. You can use the generate tool to try out queries or to do some load and performance testing.

It's also just satisfying watching the system at work via JMX or Prometheus.

<video autoplay="true" loop="true" src="/videos/crux-demo-jmx.mp4" width="100%" />

And here are some examples of the kind of random data generated.


```js
{
  'crux.db/id': { tag: 'uuid', val: 'b09e0f2c-542d-4f32-8827-4ae3437e0c8e' },
  caseId: { tag: 'uuid', val: 'b09e0f2c-542d-4f32-8827-4ae3437e0c8e' },
  caseDepartmentId: 'finance_department',
  casePatientId: { tag: 'uuid', val: '61f3e1eb-69c0-4109-86e5-b0dbfebc09f3' },
  auditUserId: { tag: 'uuid', val: '1e43642a-77e3-41c0-9c03-eeca300e99f3' }
}

{
  'crux.db/id': { tag: 'uuid', val: '61f3e1eb-69c0-4109-86e5-b0dbfebc09f3' },
  patientId: { tag: 'uuid', val: '61f3e1eb-69c0-4109-86e5-b0dbfebc09f3' },
  patientFirstName: 'Josie',
  patientLastName: 'Powlowski',
  patientBirthday: 2019-06-20T16:35:30.834Z,
  auditUserId: { tag: 'uuid', val: '7f9dfb14-4058-48b7-bd22-6247f6011fae' }
}

{
  'crux.db/id': { tag: 'uuid', val: 'fe22eacc-9caa-43d9-aa60-5638af63be97' },
  userId: { tag: 'uuid', val: 'fe22eacc-9caa-43d9-aa60-5638af63be97' },
  userFirstName: 'Rossie',
  userLastName: 'Blanda',
  userUsername: 'Rossie82',
  userEmail: 'Rossie_Blanda@yahoo.com',
  auditIntegration: 'ldap'
}
```


## Event Log

[Another demo script](https://github.com/jorinvo/crux-typescript-healthcare-demo/#follow-the-event-log) show how to follow XTDB's event log and how to process each transaction at least once.

The program stores its cursor to know what has been processed in XTDB itself.

The *follower* pattern is super useful to build any kind of external integrations. It's also useful to decouple internal logic such as sending out emails or keeping caches and search indices updated.


## Query XTDB in the REPL

Node.js has a CLI that allows you executing code interactively.

You can also build a customized REPL for your application, that knows about your application context.

The demo [contains a custom REPL](https://github.com/jorinvo/crux-typescript-healthcare-demo#javascript-repl) to interact with XTDB and shows how to extend such a REPL further.

![REPL demo screenshot](/images/crux-repl-demo.png)


----


I am happy if you give the demo a try! Play around with XTDB. Think about the possibilities of bitemporal data and event logs.

Curious to hear your thoughts. Happy to chat more about this on [Twitter](https://twitter.com/jorinvo).

-----

_Update May 2022: Crux has been renamed to XTDB and I updated the article accordingly_
