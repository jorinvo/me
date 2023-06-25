---
title: "Why Go for Node.js Developers"
date: 2017-12-14T22:20:37+01:00
---

This post is an attempt at explaining Go as an alternative to Node.js.
<!--more-->

The following is not an attempt to convince anyone that one technology is better than the other, instead I like to explore the strong points of each so we can better choose the appropriate tool for a given task.

I have been working with [Node.js](https://nodejs.org/) for more than five years now and in the last year I have been using [Go](https://golang.org/) to build various things - bigger projects and also [various](https://github.com/qvl/) open source tools.

At this point I like to document my thought process for choosing between these language for solving a given task.

This post might be the most useful for people that, like me, have used Node.js in the past and now hear a lot of talk about the success everyone has with switching to Go.

Just to be clear about it, we are talking about server-side technologies here. Some people do actually use [Go in the browser](https://github.com/gopherjs/gopherjs), but this is not what this post is about.

Also note that even if this post or other reasons convince you that you are better off using a different technology for what you are trying to do, it is [never a good idea](https://www.joelonsoftware.com/2000/04/06/things-you-should-never-do-part-i/) to rewrite your whole system at once. Find components that can be easily decoupled and make changes incrementally.

Another thing to keep in mind is to don't take *"the right tool for the job"* to an extreme. Don't underestimate the complexity of working with multiple ecosystems at once. Be careful about introducing new technology in your system. Complexity always comes with a cost.

----------

All this being said, let's talk about Go.

There are certain issues that you might run into when using Node.js, which you can solve by using Go. There are other issues Go won't solve for you. [There is no silver bullet.](http://worrydream.com/refs/Brooks-NoSilverBullet.pdf)

----------

*You might want to have a look at Go if you run into one the following issues:*

- Your software needs to run on hardware with **little available memory** or your Node application uses more memory than acceptable in other ways.

Let's compare the memory usage of these two small programs, the first in JavaScript, the second in Go:

```javascript
setTimeout(() => {}, 100000)
```

```go
package main
import "time"
func main() { time.Sleep(100 * time.Second) }
```

On my Laptop the JavaScript process uses 8.6MB while the Go one uses 380KB. The difference is not really surprising since Go is compiled to machine code upfront and has a really minimal runtime, but it is something you need to be aware of for certain kind of software.


- The application needs to **start up as fast as possible** because it restarts frequently or you are shipping CLI tools or something like that.

While Node.js has an excellent startup time compared to many other runtimes, it can't keep up with Go:

```javascript
console.log('hello')
```

```go
package main
import "fmt"
func main() { fmt.Println("hello") }
```

When running these two programs with the `time` command, the node version takes around 120ms to run while running the compiled Go program takes 10ms.


- The work a service is doing is **computing intensive** and **CPU-bound**.

Node.js is often praised for its performance for web applications compared to other environments such as Python or Ruby. That performance comes from the asynchronous programming model of JavaScript runtimes. By utilizing an event loop together with asynchronous functions a single Process can performance many tasks concurrently. However that only applies to tasks that are IO-bound — meaning tasks that are slow because they have to wait for the network or the disk. These kind of tasks are very common in web applications since they often need to get information from or to other resources such as files on disk, databases or third-party services.

If your performance is constrained by raw computing power, Go might be an interesting alternative. Through its static type system and its direct compilation to machine code, its performance can be better optimised and it is faster than any JavaScript engine in many scenarios.

Additionally Go can run code in parallel. While Node.js has a great concurrency model, it does not support parallel execution. A Node.js process always runs in a single thread. Go can utilize all CPUs the machine provides and Go comes with simple concurrency primitives built into the language. By using Goroutines and channels one has a simple way to orchestrate a parallel system without depending on mutexes and manual resources locking.

If your problem is CPU-bound and maybe even parallizable, Go should be able to give you great performance gains over Node.js.

In the extreme case Go will perform N times better — with N being the number of cores your program can make use of. But keep in mind that in many cases you can scale Node by simply running more processes. Scaling on a process level versus a thread level comes with a certain overhead, but unless you are also constrained in one of the above mentioned restrictions, it might not be an issue for you. The simplest way to coordinate multiple processes is using Nodes's [cluster module](https://nodejs.org/api/cluster.html). I also encourage you to have a look at other technologies such as [ZeroMQ](https://zeromq.org/) though.


- The **Deployment** of your application is limited by not having additional **dependencies** available on the machine or by **file size** the deployment is allowed to use.

Node.js is required to be installed on the host machine. Additionally all files need to be copied and dependencies installed on the machine using `npm install`. Dependencies often contain native C libraries and must be installed on the host itself instead upfront.

In Go the whole program and all dependencies can be compiled into a single, statically linked binary. The binaries can be cross-compiled from any platform.

The size of a Linux binary for the above *hello* Go program is **1.2MB**.

In case a system is using Docker containers, the file size savings can be even more severe:

Building the Node version using the following Dockerfile results in an image of 676MB.

```docker
FROM node
WORKDIR /usr/src/app
COPY index.js .
CMD ["node", "index.js"]
```

An image for the Go binary using the following Dockerfile results in an image of 1.23MB.

```docker
FROM scratch
COPY hello /
ENTRYPOINT ["/hello"]
```

Note that if you have many containers running and you use the same base image for them, it is reused and the disk space is only used once.

There are also [lightweight](https://hub.docker.com/_/node/) alternative containers for running Node — `node:slim` at 230MB and `node:alpine` at 67.5MB. They come with their own caveats though.

Go containers can only be this small if you don't have any external dependencies. Otherwise you might also need an Alpine or Debian image for Go and will end up at a similar images size. Also keep in mind, that to create a small Go container you need a more complex build process since you need to create the binary first and then copy it into a container.


----------

There are many other soft factors on which people base their decision of switching to Go:

- Go has one paradigm for error handling compared to 3+ ways in JavaScript.
- Go has convenient tools for testing, documenting and formatting code built into the default toolchain.
- Static typing allows for tight editor integration including autocompletion, inline docs, go to definiton, renaming symbols, …

In my opinion non of these arguments can justify rewriting an exiting codebase and it might be more benificial to invest in improving your coding guidelines in JavaScript, using tools like [prettier](https://github.com/prettier/prettier) and writing proper documentation and tests which is equally possible in JavaScript.


----------

If any of the above arguments convinced you, that Go might be a more suitable tool for the problem you are trying to solve, keep in mind that there are other languages that share many characteristics with Go. If your problem is extremely performance critical, a possibly even more suited solution might be a language such as Rust or C. Go still comes with a runtime and uses a garbage collection with can pause your program at any time. The main reason why you would look at Go instead of Rust is because the barrier to getting started is way lower. Go is a way simpler language with way less concepts to keep in your head. It is extremely quick for people to get started and be productive.


----------



## When not to use Go

If none of the above points are of concern to what you are trying to achive, you might also use any other language than Go. There is no good reason for you to throw away all your work and rewrite it in another language.

In fact I would argue that you might actually be more productive sticking to Node. JavaScript and its ecosystem come with a lot of powerful tools and abstractions, which allow you to think more about your problem domain instead of the details of the technical implementation.

Being able to load your code in a REPL and try it out and inspect your data live, allows you to explore ideas really fast. If you write automated tests - as you should in any case - you will also catch issues static typing can catch for you.

Which of these two programs would you prefer to to write, read and reason about?

This:

```javascript
const toInts = strings => strings.map(s => parseInt(s, 10))
console.log(toInts(['1', '2']))
```

Or this:

```go
package main

import (
	"fmt"
	"strconv"
)

func toInts(strings []string) ([]int64, error) {
  var res []int64

  for i, s := range strings {
    r, err := strconv.ParseInt(s, 10, 64)
    if err != nil {
      return res, fmt.Errorf("failed parsing element at index '%d': %v", i, err)
    }
    res = append(res, r)
  }

  return res, nil
}

func main() {
  fmt.Println(toInts([]string{"1", "2"}))
}
```


At this point if you feel like going deeper into a debate of static vs. dynamic languages, I recommend you [this](https://www.lispcast.com/clojure-and-types) interesting post.


----------

As you can see, there is no right answer. It depends on your problem. And even then, there might not be an obvious winner.

That being said, it is never a bad idea to explore a new language and its way of thinking. If you like to have a look at Go, I recommend you to checkout this comparison here:
[Go for JavaScript Developers](https://github.com/pazams/go-for-javascript-developers)
