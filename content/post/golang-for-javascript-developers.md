---
title: "Why Go for JavaScript Developers"
date: 2017-11-26T15:20:37+01:00
---

The following is not an attempt to convince anyone that one technology is better than the other, instead I like to explore the strong points of each so we can better choose the appropriate tool for a given task.
<!--more-->

I have been working with [Node.js](https://nodejs.org/) for five years now and in the last year I have been using [Go](https://golang.org/) to build various things.

At this point I like to document my thought process for choosing a language for solving a given task.

This article might be the most useful for people that, like me, have used Node.js to do various things in the past and
now hear a lot of talk about the success everyone has with switching to Go.

Just to be clear about it, we are talking about server-side technologies here. Some people do actually use [Go in the browser](https://github.com/gopherjs/gopherjs), but this is not what this article is about.

Also note that even if this article or other reasons convince you that you are better off using a different technology for what you are trying to do, it is [never a good idea](https://www.joelonsoftware.com/2000/04/06/things-you-should-never-do-part-i/) to rewrite your whole system at once. Find components that can be easily decoupled and make changes incrementally.

Another thing to keep in mind is to don't take *"the right tool for the job"* to an extreme. Don't underestimate the complexity of working with multiple ecosystems at once. Be careful about introducing new technology in your system. Complexity always comes with a cost.

----------

All this being said, let's talk about Go.

There are certain issues that you might run into when using Node.js, which you can solve by using Go. There are other issues Go won't solve for you. [There is no silver bullet.](http://www.itu.dk/people/hesj/BSUP/artikler/no-silver-bullit.pdf)

You might want to have a look at Go if you run into one the following issues:

- Your software needs to run on hardware with little available memory or your Node application uses more memory than acceptable in other ways.

Let's compare the memory usage of these two small programs, the first in JavaScript, the second in Go:

```javascript
setTimeout(() => {}, 100000)
```

```go
package main
import "time"
func main() { time.Sleep(100 * time.Second) }
```

On my Macbook the JavaScript process uses 8.6mb while the Go one uses 380kb. This is not really surprising since Go is compiled to machine code, but it is something you need to be aware of for certain kind of software.

- The application is invoked frequently or in another scenario that requires it to start up as fast as possible.

While Node.js has an excellent startup time compared to many other runtimes, it can't keep up with Go:
```javascript
console.log('hello')
```

```go
package main
import "fmt"
func main() { fmt.Println("hello") }
```

When running these two programs with the `time` command, the node version takes around 120ms to run while `go run main.go` takes 370ms and running the compiled Go program takes 10ms.

- performance
- small single binary for deploy (also small Docker image), cross-platform
- parallel processing with goroutines and channels
- explicit and simple error handling vs 3+ ways in JS

Soft factors:
- testing and documentation, formatting (like prettier.js) and big stdlib built-in
- editor integration (autocompletion, inline docs, go to definition - even for stdlib, rename, ...) thanks to static typing
- Simple language, no magic, quick to learn (vs Rust or C, but still GC pauses, not the right choice of super perf critical)


Great for tools
https://github.com/qvl/


When not to Go?
- If non of this is an issue for your use case, better use Node.js or another dynamic language.
  In my experience it is fast to develop. Having a REPL to experiment is great. Tests get you way further than static typing.
  Having dynamic functions, using a functional programming style and generic helpers like underscore/lodash or ramda
  allows you to think about your problem domain instead of giving your computer instructions

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

```javascript
const toInts = strings => strings.map(s => parseInt(s, 10))

console.log(toInts(['1', '2']))
```

  https://www.infoq.com/presentations/Value-Values

Why Node.js instead of Ruby, Python, ...?
- Server side rendering (e.g. React) and other code sharing
  https://github.com/zeit/next.js
- headless browsers
  https://github.com/GoogleChrome/puppeteer
- Frontend tooling
    webpack, ...
- npm


https://github.com/pazams/go-for-javascript-developers
