---
date: 2015-07-13T00:00:00Z
summary: |
  Docker and Boom helped me to emulate production conditions
  and track down a tricky bug.
title: Debug with Docker and Boom
---

I implemented a new feature for an application we use for analytics data collection.
The feature changed quite a lot of the Node.js application and also added Redis as dependency.

Tests were looking good and it was time to get it into production.
First, I was a little nervous but we had it running without any errors.

However, when I came back to work the next day,
a colleague - working on DevOps - told me the applications response time was super slow now (multiple minutes for a request).
The application has become unusable for the clients. Luckily we didn't loose any data. Most requests just time-outed.

We decided quickly to roll back and I should figure out locally where the problem comes from.
Whenever I restarted the process it was back to normal. And it just got slower over time.
So I know I had some sort of memory leak.

Before I explain how I tracked down the issue, I need to step back and give a quick overview what this application does:

The server receives analytics data and stores it in compressed files on AWS S3.
But it buffers the data in Redis until there is enough data to have a decent size to compress.

For the unit tests I limited the buffer size to something reasonable for testing.
However in production we have multiple megabytes.

To test the server under production conditions I started it up in our staging environment.
But it was not enough to send some requests manually. To get something like 500 megabytes in plain text you need to send quite a lot of requests to the API. And the latency from our Bangkok office to the AWS servers in Singapore was also slowing everything down.

I decided to spin up our [maintenance container](https://github.com/pocket-playlab/amumu/blob/master/Dockerfile) on 5 different servers and send requests from there.
With a docker infrastructure this is as simple as running this command on a server:

```bash
docker run -t -i pocketplaylab/amumu
```

Since the servers are all within Amazons data centers, the latency is pretty low.

To report on the status of the application I watched it from another terminal:

```bash
watch -n10 curl -sL -w "%{http_code}" "https://app.server.com" -o /dev/null
```

From inside a maintenance container I can watch the size of the Redis buffer grow:

```bash
watch -n1 redis-cli -h redis.server.com -n 8 strlen my-buffer
```

I just needed to send a lot of requests. My first approach was a simple shell script:

```bash
for i in {1..50000}
do
  curl -X POST \
  -H "Content-Type: application/json" \
  -H "Cache-Control: no-cache" \
  -d '{ the JSON data goes here ... }' \
  https://app.server.com \
  &> /dev/null
done
```

The performance was acceptable but it was still slow since it needs to spawn a new process each time and doesn't run in parallel.

So I gave [boom][boom] a try. I added it to the docker container and run it with 100 concurrent requests using two CPUs at a time:

```bash
boom -n 1000 -c 100 -m POST -cpus 2 -allow-insecure \
  -h content-type:application/json \
  -d '{ the JSON data goes here ... }' \
  https://app.server.com
```

With this I finally managed to fill up the buffer in a few seconds and was able to try different things to track down the bug.

The actual issue was that we measured the buffer size in bits and I used the Redis command `bitcount` to count them.

Unfortunately the command becomes slower the bigger the string in Redis is.
This was the reason the server was stuck.

To fix this we decided to set the buffer limit in characters instead of bits.
With this we can avoid the extra call to Redis because the `append` command already returns the string length.

Even if the actual bug was nothing big, it was not easy to track it down.
It's helpful to have the right tools set up in your infrastructure to test production scenarios. Having a flexible container infrastructure and tools like [boom][boom] on your hands makes the job easier.

[boom]: https://github.com/rakyll/boom
