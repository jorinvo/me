---
title: "Typescript"
date: 2017-12-10T13:16:04+01:00
draft: true
---

It gives you nice auto-completion, sometimes when everything works and you have a simple scenario.
These are probably the cases you are least in need for assistance though.

In all static languages you still need good docs the libraries you are using.
Knowing the function names and arguments is not enough to figure out the way it is intended to use.
Instead our editors should make it simple to access the docs with examples and so on.
No need for types to do this.

Typescript gives you the overhead of specifing types.
More typing and more code to look at on your screen.

It doesn't give you almost no guarranties of type safety/correctness.
I can put a string or an object into an if () statement.

You have the extra work of importing type defs for all packages you are using.

One of the main benefit that makes you productive with Javascript is the speed of trying out things.
With Typescript you need to go through a compile step now.
Your Dockerfiles gonna be more complex.
Frontend this might not be a big difference because we can't do much there without a build step,
but Node loses a lot of its flexibility and simplicity.

Your setup gets significantly more complex.


TLDR:
Sometimes you will have nice auto-completion. The rest of the time things just get more complex.
