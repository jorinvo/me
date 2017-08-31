---
date: 2014-12-06T00:00:00Z
description: |
  When working with new technologies there are always some surprises
  and it might be a good idea to take a moment after the work is done
  to think about what was good and what could be done differently.
title: Lessons Learned Building an Angular App with Node.js API
---

At [sope.io](http://sope.io/) we built a product discovery app, [Zudu](http://www.zudu.cc/).

[![Zudo Screenshot](/images/zudu.jpg)](http://www.zudu.cc/)

This are some things I learned along the way:


### Choose the Right Framework
The first version of Zudu was built using [Backbone Marionette](https://marionettejs.com/). We decided to rewrite it because Marionette turned out as unnecessary abstraction and we often had to work around it.

Writing the [Angular](https://angularjs.org/) version was straight forward and we ended up with less than half of lines of code. Also the minified version is a little smaller.

Sure, it's easier to write good code if you do it the second time, but the _Angular Way_ seems to be a better fit for this kind of application.
[Backbone](http://backbonejs.org/) is still a good tool for other use-cases.
Both have their strengths.


### Design Your API Carefully
Building a proper REST API makes the required client-side code for syncing the data quiet simple and HTTP status codes map nicely to appropriate messages for the user.
A good API Design can make a big difference.


### Build Pluggable Components
If you happen to build your own node.js framework around [express.js](https://expressjs.com/) make use of the pluggable nature of express. You can build independent components and just plug them in at whatever url you want.

```js
var hannibal = new Hannibal(config)
  .use('amazonLookup', modules.amazonLookup)
  .use('crossOrigin', modules.crossOrigin, '/')
  .use('facebookAuth', modules.facebookAuth, '/')
  .use('user', modules.user, '/users')
  .use('facebookLogin', modules.facebookLogin, '/login')
  .use('product', modules.product, '/products')
  .use('productComments', modules.productComments, '/products')
  .use('productUpdater', modules.productUpdater)
  .use('rankUpdater', modules.rankUpdater)
  .use('autoDeploy', modules.autoDeploy)
  .start();
```


### Skip Unnecessary Abstractions
[MongoDB](https://www.mongodb.org/) is a powerful and flexible database and it served use well. However, looking back I would skip the [mongoose](http://mongoosejs.com/) abstraction. The main thing mongoose gives you is validation via schemas. This makes it more familiar if you mainly worked with relational databases before. But it's not really needed for MongoDB. Having schemas you tend to think relational again.

You are better off just using the native driver for MongoDB and keep the hands from abstractions you don't need.


### Write Many Small Functions
For most server components the API is the entry point. The method handlers get easily big and complicated with asynchronous code. Make sure to separate different concerns in their own functions to avoid too many nested callbacks.

Also separate business logic from the API completely where possible.


### Wrapping Up
These might look like basic software design principles, but working with new technologies we end up running in the same pitfalls over and over again.

It's not an easy task to find the right way to use general principles in an idiomatic way for a certain software stack.
