%{
  title: "Clickhouse for Embedded Analytics: First Impressions and Unexpected Challenges",
  description: "I implemented Clickhouse for an embedded analytics project handling millions of data points, and here I share my first-hand experience with its impressive performance benefits and the unexpected challenges I encountered along the way.",
  keywords: ["clickhouse", "analytics", "database", "postgres", "OLAP"]
}

---

## The project

For a recent project, I got to help a client with the implementation of an embedded analytics system.

The system collects data from multiple internal services. The data is then prepared to build various dashboards on top of it. The dashboards will be embedded in the main application to provide customers with insights into their operations. The system needs to be flexible enough to support new use cases for using the data in the future.

In the past, I built similar systems on top of Postgres. Postgres is very flexible and it's a great default option for any data storage needs.

For this new project, we expect the number of data points to grow into the millions quickly.

It is certainly possible to handle millions of rows with Postgres. But doing analytical queries over millions of rows gets unfeasibly slow with Postgres. You end up having to deploy different caching strategies such as maintaining different pre-aggregated versions of the same data. This quickly increases the complexity of the system and makes it expensive to evolve it as new needs come up.

Analytical workloads are not the primary use case of Postgres and that's okay.

We started to look for alternatives and quickly landed at [Clickhouse](https://clickhouse.com/).

Many options were ruled out quickly because the client operates in regulated industries which require us to run the system in their own data centers.

## What we were hoping to get out of Clickhouse

1. **Raw performance:** The main benefit we get from choosing Clickhouse is the raw performance its design enables for analytical workloads. And with how fast it is by default, we can save a ton of time and keep the system simpler. We can do complex queries over millions of rows and they are fast enough without further optimization.
2. **Materialized views:** Once we do want to cache aggregated data, we can make use of incremental materialized views that are built into Clickhouse. No separate system needed for processing the data.
3. **Made for analytics:** Clickhouse comes with a ton of built-in functionality to simplify analytical queries. From supported data formats to helper functions - the available tools make our job simpler and quicker. For example, `ArgsMaxIf` simplifies our aggregate queries by a lot.
4. **Integrations:** Clickhouse comes with many integrations out of the box. In our case, we are streaming JSON data via NATS. But Kafka, S3 and many more common systems are supported out of the box. This reduces the number of moving parts needed to build a complete data platform.

## First impressions

I always feel a bit intimidated by technology that is intended to operate at the scale of millions of events per second and petabytes of data.

But it was surprisingly simple to get started with the [Clickhouse Docker image](https://hub.docker.com/r/clickhouse/clickhouse-server/). It's well documented. The whole documentation of Clickhouse is simple to read and navigate. And the CLI tools feel modern and intuitive to interact with.

## Surprises we ran into

When first reading about how fast Clickhouse is for analytical workloads, it feels like magic. Of course, they are not hiding that there are tradeoffs to get the system to be this performant. But reading about a system not having transactional guarantees and encountering it in practice are very different things. The following are what I wish I knew before getting started:

1. **Table Engines:** You have to [select an engine](https://clickhouse.com/docs/en/engines/table-engines) for each table you create. And this is not only an afterthought. If you want to replace old values with new ones, you need a different engine than if you only append new data. And if you aggregate or summarize values, there are specific engines for that. I can't say I understand all available engines yet. It takes some time to understand which one to pick.
2. **Encountering duplicate data:** The [ReplacingMergeTree](https://clickhouse.com/docs/en/engines/table-engines/mergetree-family/replacingmergetree) table engine replaces existing rows and allows you to basically do UPSERT. But the old data will not be removed directly. Duplicate rows will only be removed asynchronously. Also, setting a primary key only affects how data is stored on disk, but doesn't guarantee unique values. There are ways to get unique query results, but it takes some extra care. You can ensure unique rows using `GROUP BY` at query time and there are also settings like `FINAL` and `optimize_on_insert` that remove duplicates for a performance penalty.
3. **Incremental Materialized Views are not always updated:** In Clickhouse, Materialized Views are incrementally updated automatically. This was a main selling point that convinced me that it can simplify the system by a lot. Materialized Views behave like insert triggers. The database client that does an `INSERT` on a parent table receives an error if updating any materialized view failed. But there are actually no transactional guarantees around this and the data is still written to the parent table. We work around this by using a `ReplacingMergeTree` as parent table to deduplicate data and resend failed events using NATS to retrigger the Materialized View.
4. **Joins in Materialized Views are hard to get right:** Materialized Views support joins and sub-queries. But Incremental Materialized Views are implemented as triggers on a single parent table. If data in a joined table changes, the view is not updated. This is not directly mentioned in the documentation. I only later found a [blog post](https://altinity.com/blog/2020-07-14-joins-in-clickhouse-materialized-views#h-a-dive-into-the-plumbing) mentioning this. While the docs don't mention this limitation directly, [they do mention](https://clickhouse.com/docs/en/guides/developer/cascading-materialized-views#combining-multiple-source-tables-to-single-target-table) a way to work around it: You can create multiple Materialized Views that write to the same table. If you use the `AggregatingMergeTree` table engine, you can combine data from multiple parent tables by writing into separate columns. It's not the most intuitive to work with and think through the performance implications of it though.
5. **No NATS Jetstream support:** I was amazed that we can integrate data from NATS without any additional infrastructure. After wondering why it doesn't work as expected, I found out that [Jetstream is not yet supported](https://github.com/ClickHouse/ClickHouse/issues/39459). So for the time being, we have a small ingest service to get the data guarantees we need.

The surprises we encountered are understandable tradeoffs that come with the chosen system design behind Clickhouse and luckily we can work around all of them.

Overall, getting started with Clickhouse was a smooth experience. Let's see how the system is holding up a few months into the future.
