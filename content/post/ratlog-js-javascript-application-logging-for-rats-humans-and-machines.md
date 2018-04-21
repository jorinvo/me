---
title: "Ratlog.js – JavaScript Application Logging for Rats, Humans and Machines"
date: 2018-04-21T20:25:56+02:00
---


I am unsatisfied whenever I have to look at the logs in a Node.js project.
Ratlog is an attempt to fix this.
<!--more-->

The typical way of logging in Node.js is to use [Bunyan](https://github.com/trentm/node-bunyan) or [Winston](https://github.com/winstonjs/winston).
Both of them are mature libraries and they come with lots of options:

You can configure transports to write logs to different locations, you can specify the output format in flexible ways, many data points such as timestamps and log levels are included by default.

They use JSON as output format to be flexible and compatible with other platforms. They also offer neat CLI-tools to pretty-print the JSON output when viewing the logs.

But all this flexibility makes working with logs cumbersome.

These features might be helpful to many people in many scenarios. But if you don't have huge infrastructure around logging to centralize and query them, these features are in your way.

**I just want to see what's going on in my application.**

- [stdout](https://en.wikipedia.org/wiki/Standard_streams) is the right place for logs. If I want them somewhere else, I can redirect stdout.
- I don't want the log format to be configurable. I want it to be consistent.
- I don't want to have to use another tool to read the logs. They should be readable right away. JSON is not readable.
- I don't even want stuff like log levels and timestamps. When I read logs it's mostly via tools such as `docker` or `journalctl`. They already collect all meta infos such as timestamps, host info, service name, ...

And even though those libraries have many features and include a lot of meta information, they don't help me with tools to structure the actual logs.

---------------


**So what I came up with is [Ratlog](https://github.com/ratlog/ratlog.github.io/).**

Ratlog is a specification of a logging format that is focused on being readable, informative, simple and still machine-parsable.

Additionally I created [Ratlog.js](https://github.com/ratlog/ratlog.js), a really simple JavaScript logging library, which supports the Ratlog semantics to make it simple to create helpful logs.

---------------


Let's have a quick look at some output of a basic [example application](https://github.com/ratlog/ratlog.js/blob/master/examples/component-with-metrics.js):

```
app starting
[counter] starting
[counter] started
app ready
[counter|event] counting | count: 1
[counter|event] counting | count: 2
[counter] stopped
app shutting down
```

Reading the output of a service might look like this:

```
$ docker logs -t myapp
2018-03-29T11:10:29.116Z [file-import|warning] file not found | code: 404 | path: /tmp/notfound.txt
```

```
$ journalctl -u myapp
Apr 13 22:15:34 myhost myapp[1234]: [http|request|error] File not found | code: 404 | method: GET | route: /admin
```

You can use all the default Unix tools to filter, query and manipulate the output:

```
$ journalctl -u myapp | grep '\[|\|warn' | less
```

Logs consist of **message**, **tags** and **fields**:

- The *message* is the most basic element of a log.
- It can be put into context using *tags*. Tags can be used in flexible ways to signal log levels, severity, component hierarchy and many other properties.
- Additionally logs can be augmented with more data using *fields*.

---------------


**How do you get started logging?**

- Install the [ratlog](https://www.npmjs.com/package/ratlog) NPM package

```
npm i ratlog
```

- Starting logging

```js
const log = require('ratlog')(process.stdout)

log('hello world')
// => hello world

// Add fields
log('counting', { count: 1 })
// => counting | count: 1

// Add fields and a tag
log('counting', { count: -1 }, 'negative')
// => [negative] counting | count: -1

// Create another logger bound to a tag
const warn = log.tag('warning')

warn('disk space low')
// => [warning] disk space low

// Combine and nest tags any way you like
const critical = warn.tag('critical')

critical('shutting down all servers')
// => [warning|critical] shutting down all servers
```


You can find out more about [Ratlog.js](https://github.com/ratlog/ratlog.js) and the [Ratlog Spec](https://github.com/ratlog/ratlog.github.io) on GitHub.

I would be really glad about hearing your thoughts, critique and feedback!

It is also simple to implement a Ratlog-compatible logger or parser in any other programming language.
There is a [JSON test suite](https://ratlog.github.io/ratlog.testsuite.json) so you don't have to bother writing tests.
