---
title: "Crux Healthcare Typescript Demo"
date: 2021-01-22T15:58:06+01:00
unlist: true
---

Crux is a great fit for healthcare applications. Let's see how to use it JavaScript land.<!--more-->


## Why Crux for Healthcare?

[Crux](https://opencrux.com/main/index.html) is an unbundled, bitemporal document store.

Let's unwrap this.

[![crux logo](https://raw.githubusercontent.com/juxt/crux/master/docs/reference/modules/ROOT/images/crux-logo-banner.svg)](https://opencrux.com/main/index.html)

The term *unbundled* comes from the [origin of Apache Kafka](https://martin.kleppmann.com/2015/03/04/turning-the-database-inside-out.html). Most databases use an event log internally for sending state to different parts of the system reliably. We now know that this pattern is also pretty useful in the bigger picture. It's especially useful when you have to build systems with lots of integrations. Not surprisingly a complex industry such as healthcare is made up of many sub-systems that all need to exchange data. HL7 or FHIR anyone? Having a solid foundation to build on helps a great deal with getting data synchronisation right.

With a *temporal* data store you store all of history. You will always know about all changes to the data.
With a *bitemporal* data store you store history, but you can fix errors in historic values. And you still have a record of all changes.
Turns out that both, fixing error and keeping a record of all changes, are pretty handy when working with critical patient data.
Existing regulations, audit requirements and demands for data integrity basically force you to model your system this way.

Crux makes sure you do know about every change to data, but at the same time you have the ability to erase data completely. [evict](https://opencrux.com/reference/20.09-1.12.1/transactions.html#evict) makes sure you can be GDPR-compliant.

Lastly, Crux stores documents. You do not define schemas and relationships upfront. You can write any documents to the system.
Why is that helpful? Healthcare made up of many complex sub-systems generating different data. While rather slow-moving, also health tech is picking up a faster pace of change.
You need a way to deal with incomplete data, changing requirements and questions you didn't now will come up in the future.
Modeling constraints becomes so complex that a single, consistent model is not enough. You need more flexibility in asserting facts about your data.
Let the data store take care of storing data. Model your application logic in your application.

To sum it up,

**Crux is designed for complex systems with strict data integrity needs.**

**Healthcare is such a system.**


## Why JavaScript? Why Typescript?

The short answer is, *they are popular*.

JavaScript makes software development accessible to so many people. They shouldn't miss out on Crux.

TypeScript has also become more popular lately. It can help making a code base more robust and enables great IDE tools. This is especially helpful as projects become bigger.

If we can provide a clearly defined interface for Crux in TypeScript, its usage becomes straight forward.


## Demo Time

I created a demo for people to see how such a setup could look like.

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

You can find it [on Github](https://github.com/jorinvo/crux-typescript-healthcare-demo/).

The example runs a minimal Crux setup via [Docker and Compose](https://docs.docker.com/compose/).

The Crux configuration stores data in RocksDB. Crux provides an HTTP API which we can use from JS land. The estup also demos JMX and Prometheus metrics to watch what's going on in the database. You can find all the details in the readme.

The Node.js application talks to Crux via EDN over HTTP. I implemented a TypeScript interface on top of that. It's documented [here](https://github.com/jorinvo/crux-typescript-healthcare-demo#api-overview) and you can easily see [how it is done](https://github.com/jorinvo/crux-typescript-healthcare-demo/blob/master/client/src/crux/index.ts). We use [edn-data](https://github.com/jorinvo/edn-data) to talk to Crux.


## Generate Data

Part of the demo is a tool that [generates](https://github.com/jorinvo/crux-typescript-healthcare-demo#data-generator) some healthcare-inspired data you can use to try out queries or to do some load and performance testing.

It's also just satisfying watching the system at work via Prometheus and JMX.

[JMX and prom screen]

Here is some sample data:


## Event Log

There is a demo how to build a follower of Crux's event log and how to process each transaction at least once.

The program stores its cursor to know what it processed already in Crux itself.

The *follower* pattern is super useful to build any kind of external integrations. It's also useful to decouple internal logic such as sending out emails or keeping caches and search indices updated.

  - Show example of in action
    - GIF
    - Stores its cursor in Crux itself
    - Initially catches up
    - Then follow while `npm run gen` is still running


## Query Crux in the REPL

Node.js has a CLI that allows you executing code interactively.

You cannot only use the default but also build a customized REPL for your application, which then also can have some other context available.

The demo [contains a custom REPL](https://github.com/jorinvo/crux-typescript-healthcare-demo#javascript-repl) to interact with our data and show how to extend such a REPL further.



- Built a custom node.js REPL
  - Show some examples


----

I am happy if you give the demo a try! Play around with Crux. Think about the possibilities of bitemporal data and event logs.

Curious to hear your thoughts. Happy to chat more about this [on Twitter](https://twitter.com/jorinvo)!
