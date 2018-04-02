---
title: "Prometheus Not Only Cloud Native"
date: 2017-12-22T18:08:24+01:00
draft: true
---

It's also great for smaller, even single machine use cases.

Clients are easy and you can track everything, not only machine metrics, business values too.

Single binary, automatically tracks uptime, storage is built-in, PromQL interactively in interface,
alerts are easy, low overhead, ...

federation is super easy to aggregate from instances

use it for all the things you want to see from in your system,
but: don't trust prom's accuracy - it can drop events
it's focus is on alterting you not on being 100% accurate.
always report current state and don't let Prometheus do the counting



But: Is there a better way? Is f.e. Influx even easier? Something more persistent?
Influx query language is not that nice ...

Or can you simply do this with SQL? SQL is not good with dynamic label names I guess.
How to do graphing and alterting nicely?

Want an all-in-one solutions for small load use cases. Also want to extract data, sending it to other services.

Riemann? Elasticsearch + Grafana?

