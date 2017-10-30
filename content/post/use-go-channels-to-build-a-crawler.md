---
title: "Use Go Channels to Build a Crawler"
date: 2017-10-11T13:38:24+02:00
---

Learn how to use channels to model your data flow by building a web crawler in Go.<!--more-->

The other day I built a crawler that checks links on your website to see if there are any links that you can update from HTTP to HTTPS.
You can find it at [qvl.io/httpsyet](https://qvl.io/httpsyet).

I came up with an implementation that abstracts the coordination using channels and I would like to share it in this article.

Let's start with the requirements:

The program should start with the URLs we pass to it, find all links on the site, and traverse through all sub-pages recursively.
All external links that start with `http://` should be tested if they also work with `https://`.
And all this should happen in parallel.

*Note that I skip validation and some settings in this article.*

The crawler is a settings `struct` with a single function.

```go
type Crawler struct {
	Sites    []string  // At least one URL.
	Out      io.Writer // Writes one site per line.
}

func (c Crawler) Run {}
```

The above is similar to having a function that takes the settings as argument, but it allows users of the package to write `httpsyet.Crawler{}.Run()`
<br>
instead of `httpsyet.Run(httpsyet.Crawler{})`.

Now let's see how we can use channels to implement the architecture.

First, we want to output all URLs that can be updated.
We don't simply return them synchronous from the `Run` function,
but instead we write them to an `io.Writer`, which is specified in the `Crawler` as `c.Out`.
Since the crawling should happen in parallel and it is not guaranteed that the `io.Writer` is safe to use concurrent,
writing to the output is better abstracted using a channel:

```go
results := make(chan string)
defer close(results)
go func() {
  for r := range results {
    if _, err := fmt.Fprintln(c.Out, r); err != nil {
      c.Log.Printf("failed to output '%s': %v\n", r, err)
    }
  }
}()
```

Before we can start the parallel workers for crawling, we need a way to send new sites to the workers.
However, a single channel is not enough, because the workers themselves collect more sites from links, which also need to be queued for crawling and
with a single channel there would be no way to know, that there are no more sites to be crawled.
Additionally, we need to make sure to crawl each URL only once to not get stuck in a loop when links reference to the current or a parent site.

What I came up with is a function `makeQueue` that returns three channels:

```go
func makeQueue() (chan<- site, <-chan site, chan<- int) {
	queueCount := 0
	wait := make(chan int)
	sites := make(chan site)
	queue := make(chan site)
	visited := map[string]struct{}{}

	go func() {
		for delta := range wait {
			queueCount += delta
			if queueCount == 0 {
				close(queue)
			}
		}
	}()

	go func() {
		for s := range queue {
			u := s.URL.String()
			if _, v := visited[u]; !v {
				visited[u] = struct{}{}
				sites <- s
			} else {
				wait <- -1
			}
		}
		close(sites)
		close(wait)
	}()

	return queue, sites, wait
}
```

Let me explain what this does:

- `sites` is a readable channel. This is the channel the workers should *range* over and crawl sites from.
- `queue` is a writable channel in which all sites that need to be crawled should be send.
The sites should not be send to `sites` directly because `queue` internally tracks all sites in a `visited` *set* to make sure each site is only crawled once.
- I said `visited` is a *set* but Go has no *set* data type.
However using a `map` with empty `struct{}` as value type can be used instead.
- `wait` is another writable channel.
Internally `makeQueue` keeps a counter of how many more site will be queued.
By sending values to `wait`, we can change that counter.
For every site that we crawled we send `wait <- -1` and for all new sites we queue we send `wait <- len(sites)`.
As soon as the counter reaches 0, we know there will be no more sites to crawl.
- Since we have the `wait` channel, which tracks when we are done crawling, all channels can be closed internally once done.
The caller of `makeQueue` never has to close any channel.
The caller can simply *range* over `sites` until the `wait` counter reaches 0.

Next, we want to start a number of workers that crawl sites in parallel.
This is such a common scenario that there is a tool for it in the Go standard library, [`WaitGroup`](https://golang.org/pkg/sync/#WaitGroup).

```go
var wg sync.WaitGroup
for i := 0; i < 10; i++ {
  wg.Add(1)
  go func() {
    defer wg.Done()
    // Pass channels to each worker
    worker(sites, queue, wait, results)
  }()
}

wg.Wait()
```

With this setup, we start 10 workers and block until all of them exit.

Each worker looks like the following. Error handling and logging is removed here.

```go
func (c Crawler) worker(
  sites <-chan site,
  queue chan<- site,
  results chan<- string,
  wait chan<- int,
) {
  for s := range sites {
    urls, shouldUpdate := crawlSite(s)

    if shouldUpdate {
      results <- fmt.Sprintf("%v %v", s.Parent, s.URL.String())
    }

    wait <- len(urls) - 1

    go queueURLs(queue, urls)
  }
}
```

The workers internally *range* over the `sites` channel,
which means that all workers run until `sites` is closed.
As described before, `sites` is closed automatically in `makeQueue` as soon as the wait counter reaches 0.
<br>
The workers send links that can be updated to HTTPS to the `results` channel.
And each worker queues the links found on a site.
The queuing itself happens in a separate Goroutine, which simply sends the links to `queue`.
By updating the wait count before queuing, the queue knows that there are more sites to come.

Note that `wait <- len(urls) - 1` combines counting down -1 for the current site and counting up for all sites to be queued.
If we would count down before counting up, the wait counter could reach 0 before we are actually done.

We could also use a [buffered channel](https://gobyexample.com/channel-buffering) instead of queuing in the background,
but this would force us to set a fixed buffer size.
By using Goroutines to queue in the background, the workers are available to keep crawling sites and we buffer sites that need to be queued in memory.

The last piece missing to start the crawler is queuing initial the sites.
This needs to happen after all the other setup is done, but right before the `wg.Wait()` call:

```go
for _, u := range urls {
  queue <- site{
    URL:    u,
    Parent: nil,
  }
}
```

Not all details of the implementation have been covered here and I encourage you to have a look at the source [on Github](https://github.com/qvl/httpsyet).
This article focuses on the usage of channels to handle communication in a concurrent scenario, that requires a little more than a single channel, four channels and one `WaitGroup` to be exact.

Please let me know if you have any questions and I would be really interested to hear about other solutions for this scenario!
