---
title: "Migrating Data When You Never Erase History"
date: 2020-10-25T16:48:46+02:00
---

Let's explore the considerations necessary when evolving temporal data over time.<!--more-->

Almost all actively used software evolves over time. Most software also includes certain data that is stored long-term. The database behind such applications tends to be slower-changing than any particular application logic. However, the underlying data still evolves over time as requirements change. Migrations of data are already a challenge. If you now persist the history of the data changes over time and your requirements evolve in time, you now have to consider these changes not only at a specific point in time but along the whole temporal dimension.

To make any decision about migration strategies in a particular system, you have to understand the context the data is used in.

*Feel free to skip sections and jump to the ones relevant to you.*

## Why keep history?

Many things become possible once you store change events and thus the previous state of a software system.

One of the most obvious uses of historic data is implementing requirements for auditing and version control in critical applications.

Having historic data also becomes invaluable for understanding and debuging complex processes. It is not only helpful for developers but also for users trying to understand the processes of the bigger system the software is used in.

From a technical perspective building solid, fault-tolerant, distributed software that interacts with external systems becomes more feasible once you have a log of change events. You can replay the events at any time to recreate the state of different sub-systems which is a big help keeping everything in sync without running into race conditions.

The value of storing historic data is huge and often the need for it will only arise later on. I argue that all software should be built this way by default. Ignoring history should be merely a possible performance optimisation for scenarios required that.


## How to store history?

Storing historic data can be achieved in many ways. In a large-scale architecture it might be interesting to work with raw events. [Apache Kafka](https://kafka.apache.org/) is a great store for raw events. Having raw events directly accessible as interface for interactions provides a lot of flexibility and control necessary to work at scale. However, it also requires building a lot of logic on top to recreate a view of the current state of the world.

There are databases such as [Datomic](https://www.datomic.com/) which is specifically designed for keeping all history of the data around. With Datomic the database takes care of keeping history while you can work with the current state of the system. The same queries you use to query the current state can then be used to query any previous point in time. Datomic also allows you to look at time ranges. It also provides functionality to follow the log of changes to work with the change events continuously.

[XTDB](https://xtdb.com/) is a temporal database that allows you to work with historic data in similar ways to Datomic, but XTDB is not only a temporal database but a _bitemporal database_. XTDB not only stores the time you inserted data into the database, also referred to as *transaction time*, but also allows you to specify another time dimension called *valid time*. By differentiating what the system knew at a certain transaction time and what was the actual state of the world at a given valid time, you can accurately update not only the current state but also knowledge about the state in the past. This can be a crucial tool when you need to be able to correct historic data and at the same time have the requirement of knowing precisely what change was done at what time. I would argue that this is the only way to accurately represent historic data when you want to work at the level of entities and attributes and not at the level of raw change events.

The **SQL standard** also specifies the concept of *temporal tables*. [SQL Server](https://docs.microsoft.com/en-us/sql/relational-databases/tables/temporal-tables?view=sql-server-ver15) implements this and allows for automatic versioning of tables in what they call *system time*, which we described before as transaction time. This is internally implemented by having a separate history table, plus providing additional syntax to query data at a point in the past. [MariaDB](https://mariadb.com/kb/en/temporal-data-tables/) is another SQL database that supports temporal tables. MariaDB goes even further and also supports bitemporal data using a second time dimension here referred to as *application time*, which matches the earlier introduced valid time.

Apart from existing implementations of temporal and bitemporal datastores, there are also use cases with needs for scale and operational characteristics, which might be best served by implementing a custom solution on top of another storage.


## Keep history forever?

Different use cases of historic data demand different strategies for data retention. Ideally you can always keep all data around forever. Unfortunately that can become unfeasible in certain situations. In that case you have different options to reducing the number of data points you have to retain:

- Completely erase old data after a certain expiration time or through other expiration policies.
- Delete the data itself but keep meta data around.
- Keep old data in lower granularity. For example, only keep one data point per day per entity for data older than a week.
- Merge multiple data points into one using a merge logic specific to your needs.

An important property to consider when planning a retention strategy is the ability to recreate the current state from the log of historic data.


## How do you use historic data?

- Do you control the code that receives the data? Can you update it in sync with changes to the data schema?
- Are the use cases of the current view of the data and historic data separate from each other?
- Often most parts of an application use only the current state and historic data is only used in a small number of places. Can you require a stricter schema for the current state and a looser one for historic data?
- In case you have two time axis, such as valid time plus transaction time, there might be different features building on each of them. Likely there are more use cases of valid time than transaction time.
- Do you know the data schema version that downstream consumers support? Can you remove support for deprecated data features once all consumers are on a recent version?


## What changes to the data do you need to make?

The most important thing to consider when changing data is that you want to **avoid breaking changes**.

When the logic of your system evolves it sometimes becomes necessary to change the shape and thus the schema of the data the system works with. This can come in different forms:

- Adding a new optional attribute is a non-breaking change. Explicit, maybe even namespaced, attribute names help to keep clarity and avoid conflict.
- Adding a required attribute or making a previously optional attribute required, is a breaking change.
- Can you introduce a new attribute instead of renaming an existing one? Mark the old one as deprecated, but leave it there for consumers of historic data.
- If you must change the type of an attribute, can you extend it instead? Instead of changing from `string` to `integer`, can you use a union type of `string or integer`?
- Removing data will break downstream code that depends on it.

Sometimes we don't have to change the shape of data but the data itself. This is especially common if there has been an error in the system and we have to correct or even delete erroneous data.
Changes to the data itself can be seen as normal updates to the current state of the sytem. A temporal storage then gives you a record of everything for later reference. A bitemporal system also allows you to correct errors in historic data while keeping a record of everything.


## Do data changes only apply to current state of data or also historic data?

- If you introduce a new attribute, do you only need it in the current view of the data or do you need to generate it also for historic data? Is it even possible to reconstruct the attribute for past data points?
- If you work with valid and transaction time, is it enough to introduce a new attribute for historic data in valid time or do you also need to rewrite transaction time?
- When removing data, can you keep meta data or do you need to remove every trace that a certain event ever happened?
- For deletion or modification of historic data, how does that propagate to downstream, maybe external, consumers?
- Do you explicitly need to remove a specific attribute from all of history or can you model data in a way that you can delete whole documents instead? Depending on the system, deleting whole documents might be simpler to implement. How does that affect the schema of the documents in your system and the relations between them?
- Before a data type schema becomes too complex, can you introduce a new data type instead? Or maybe you want a concept of versioning for types? You can save a specific `version` attribute with every entity and use that to handle different types through this. Or can you even version attributes themselves?
