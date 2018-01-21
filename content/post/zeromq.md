---
title: "Zeromq"
date: 2017-12-10T19:36:06+01:00
draft: true
---

how to do zeromq in 2017

microservices is big, don't do HTTP

fast, keep one connection open

zeromq is fast, made for finance
multiple protocols, start with tcp or ipc

handles reconnection for you

use any format, start with JSON optimise with Protobuffers or something

no broker, no single point of failure

but still, dynamically scale number of job workers and event subscribers without need for service discovery

system can automatically handle high loads because zeromq handles message queueing or dropping for slow consumers and does fair load balancing for you

HTTP is complicated:
method+statuscode+route+query+body
why not simply one JSON object


one lib for all your communication needs:
HTTP requests => req-res, broadcast => pub-sub, Queue => push-pull


most APIs are HTTP, it's RPC.
how to send many parallel requests through one connection?
-> example
how to add timeouts, retries, error handling?
-> example

how to queue jobs?
-> example

Be care full ZeroMQ is fast. Really fast.
You can get an answer from your service faster than your actual code executes two lines.
