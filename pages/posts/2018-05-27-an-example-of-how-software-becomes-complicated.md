%{
  title: "An Example of How Software Becomes Complicated",
  description: "Let's write a cache in JavaScript and see what it means to keep things simple.",
  keywords: ["software", "design", "programming", "javascript", "KISS"]
}
---

We always hear software developers saying things like *we should keep things simple* and *we need to control complexity*. At the same time we advocate to *reuse* and *share* code, and to make things *easy to extend*.

When writing software it is very easy to end up with code [more complicated than complex](https://www.youtube.com/watch?v=ubaX1Smg6pY), that tries to do too many things and is hard to work with.

Everyone tells you to keep it simple. And basically all of us generally agree that it sounds like a reasonable thing to do. If we all are aware of our goals, how come that so many times as projects evolve over time things become such a mess and so hard to work with?

Maybe we need more examples of what it means to strive for simple solutions.

--------------------

Let's build a simple cache.

The cache should allow us to set key-value pairs and retrieve values a single time.

A simple implementation could look like this:


```js
const cache = () => {
  const store = {}

  const set = (key, value) => {
    store[key] = value
  }

  const remove = key => {
    const value = store[key]
    delete store[key]
    return value
  }

  return { set, remove }
}

// Let's use the cache

const simpleCache = cache()

simpleCache.set('a', 1)
simpleCache.set('b', 2)
simpleCache.set('b', 3)

console.log(simpleCache.remove('a')) // 1
console.log(simpleCache.remove('b')) // 3
console.log(simpleCache.remove('b')) // undefined
```

Now as the project evolves you get new requirements and the cache also needs to expire items stored in the cache. A *time to live* (*TTL*) should be specified and a callback function executed every time a cache item expires. You change the code accordingly:


```js
const cache = (ttl, expirationHandler) => {
  const store = {}

  const set = (key, value) => {
    // Clear existing timer
    const record = store[key]
    if (record) {
      clearTimeout(record.timer)
    }
    // Set expiration timer
    const timer = setTimeout(() => {
      expirationHandler(key, store[key].value)
      delete store[key]
    }, ttl)
    // Store timer and value
    store[key] = { timer, value }
  }

  const remove = key => {
    // Find record
    const record = store[key]
    if (!record) {
      return undefined
    }
    delete store[key]
    const { timer, value } = record
    // Clear timer and store
    clearTimeout(timer)
    return value
  }

  return { set, remove }
}


const expirationHandler = (key, value) => {
  console.log(`expired ${key}: ${value}`) // expired b: 2
}
const expiringCache = cache(1000, expirationHandler)

expiringCache.set('a', 1)
expiringCache.set('b', 2)

console.log(expiringCache.remove('a')) // 1
console.log(expiringCache.remove('a')) // undefined
setTimeout(() => {
  console.log(expiringCache.remove('b')) // undefined
}, 1100)
```

Everything is working great, then, while reviewing your code, your coworker notices that the same cache is used in another situation that strictly requires items in the cache to never expire.

Now you could simply keep the old and new cache implementation in your code base, but you prefer to keep things [DRY](https://en.wikipedia.org/wiki/Don%27t_repeat_yourself).

So instead you adjust the new cache to support both use cases:

```js
const cache = (ttl, expirationHandler) => {
  const store = {}

  const set = (key, value) => {
    // If no TTL is specified, behave as before and return early
    if (!ttl) {
      store[key] = value
      return
    }
    // Clear existing timer
    const record = store[key]
    if (record) {
      clearTimeout(record.timer)
    }
    // Set expiration timer
    const timer = setTimeout(() => {
      expirationHandler(key, store[key].value)
      delete store[key]
    }, ttl)
    // Store timer and value
    store[key] = { timer, value }
  }

  const remove = key => {
    // Find record
    const record = store[key]
    if (!record) {
      return undefined
    }
    delete store[key]
    // If no TTL is specified, behave as before and return early
    if (!ttl) {
      return record
    }
    const { timer, value } = record
    // Clear timer and store
    clearTimeout(timer)
    return value
  }

  return { set, remove }
}

// Let's use the simple cache

const simpleCache = cache()

simpleCache.set('a', 1)
simpleCache.set('b', 2)
simpleCache.set('b', 3)

console.log(simpleCache.remove('a')) // 1
console.log(simpleCache.remove('b')) // 3
console.log(simpleCache.remove('b')) // undefined

// Let's use the expiring cache

const expirationHandler = (key, value) => {
  console.log(`expired ${key}: ${value}`) // expired b: 2
}
const expiringCache = cache(1000, expirationHandler)

expiringCache.set('a', 1)
expiringCache.set('b', 2)

console.log(expiringCache.remove('a')) // 1
console.log(expiringCache.remove('a')) // undefined
setTimeout(() => {
  console.log(expiringCache.remove('b')) // undefined
}, 1100)
```

That was quick. All you had to do was adding two *IF* statements.

And this is how things get complicating: The simple cache is not simple anymore but entangled with the expiring cache. The simple scenario became harder to understand, slower and there are more opportunities to introduce bugs.

**Every time you implement a feature by *simply* adding one more *IF* statement, you help growing it further – [the big ball of mud](https://www.joeyoder.com/PDFs/mud.pdf).**

How can we keep the original cache simple?

*Duplicate code instead of making simple things complex.*

When you copy code it becomes easier to see which parts you can share and reuse.

Build specialized tools, each doing one thing. And compose those tools to build other tools.

This has been said [many times before](https://en.wikipedia.org/wiki/Unix_philosophy).

How can we create an expiring cache without complicating the simple cache?

In our example the expiration behavior can be easily built on top of the initial cache implementation:

```js
const cache = () => {
  const store = {}

  const set = (key, value) => {
    store[key] = value
  }

  const remove = key => {
    const value = store[key]
    delete store[key]
    return value
  }

  return { set, remove }
}

const expire = (cache, ttl, expirationHandler) => {
  const timers = {}

  const set = (key, value) => {
    // Store value
    cache.set(key, value)
    // Clear existing timer
    clearTimeout(timers[key])
    // Set expiration timer
    timers[key] = setTimeout(() => {
      const value = cache.remove(key)
      delete timers[key]
      expirationHandler(key, value)
    }, ttl)
  }

  const remove = key => {
    clearTimeout(timers[key])
    delete timers[key]
    return cache.remove(key)
  }

  return { set, remove }
}

// Let's use the simple cache

const simpleCache = cache()

simpleCache.set('a', 1)
simpleCache.set('b', 2)
simpleCache.set('b', 3)

console.log(simpleCache.remove('a')) // 1
console.log(simpleCache.remove('b')) // 3
console.log(simpleCache.remove('b')) // undefined

// Let's use the expiring cache

const expirationHandler = (key, value) => {
  console.log(`expired ${key}: ${value}`)
}
const expiringCache = expire(cache(), 1000, expirationHandler)

expiringCache.set('a', 1)
expiringCache.set('b', 2)

console.log(expiringCache.remove('a')) // 1
console.log(expiringCache.remove('a')) // undefined
setTimeout(() => {
  console.log(expiringCache.remove('b')) // undefined
}, 1100)
```

In some cases like this example tools compose well. In other scenarios only parts can be reused. Moving parts of the logic to separate functions allows you to share them, to use them as tools on their own.

Remember to watch out whenever you introduce a new condition in an existing program. Think about which parts can be separate, reusable tools of their own. Don't be afraid of copying code.

