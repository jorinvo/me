---
title: JS Graphic Designer
summary: >
---

## General Points

- Graphics is hard. Probably the most difficult part of computing I encountered. Don't underestimate it. It's math:

```js
var x = app.utils.pageX(e) - data.pos.x;
var y = data.pos.y - app.utils.pageY(e);
var alpha = -Math.atan2(y, x) * RAD_TO_DEG;
app.utils.svgRotate(app.selected, alpha);
app.emit('rotate', el);
```

It's lots of edge cases. Tests are hard to automate.
Interactive tools like this have lots of state/IO/side effects. It's hard to have pure functions to reason about.
I estimated the timing completely wrong. Wrong as in it took more than 10 times as long.

- Have to work on the edge of browser technology to make this work. People talk about the great HTML5 world. I had a lot of issues when I tried running it in different browsers.
I used a lot of new browser APIs: requestAnimationFrame, Promise, XMLSerializer, Blob, FileReader, URL.createObjectURL, Uint8Array, hidden canvas for image manipulation, SVG transform, no jquery (querySelector, classList, matchesSelector, getBBox, getBoundingClientRect, and so on ...)

- It would be nice if SVG would be more integrated into the Web. It looks like HTML and you can use it with the same DOM functions. Sometimes. Unfortunately a lot of things are repeated in SVG. Especially CSS things. A lot of positioning and transforming and animating can be done via CSS or SVG. Why not sticking to just one option?


## Good ideas

- Expose a nice API to the user (chaining helps).
  And it's really simple to add this extra sugar:

```js
Object.keys(graphicDesigner.plugins).forEach(function(key) {
  app[key] = function(options) {
      var plugin = graphicDesigner.plugins[key];
      plugin(app, utils.defaults(options, plugin.defaults));
      return app;
  };
});
```

- Use a plugin system

- Build plugins as features rather than just visual components. Can deactivate a whole feature by ignoring a plugin.

- Promise flows can create nice declarative code:

```js
singleFile(e.dataTransfer.files)
    .then(readImage)
    .then(scale)
    .then(placeAt(e))
    .then(create);
```

I'm looking forward to make that even more usable using Streams!

- An event emitter is a really simple concept and can get you really far. I wrote my own event emitter in just ~30 lines of code. But it can also be cumbersome to keep changes in sync.
I'm looking forward to look more into reactive libraries to make this tasks easier!


## Bad ideas

- It's a well known best practice to separate data and presentation.

I tried using a new fancy library (Ractive.js) for my first attempts. But the interaction felt kind of slow. I don't think it's Ractive's fault and I would love to find a library that enables me to ignore the browser part of things, only work on my data.
It was painful having all the state inside SVG and DOM. If anyone has got experiences with good performing interactive graphics using a library like React or Angular, please let me know!
(This project was before I ever got my hands on React.)
I would love to give it a try for a project like this next time!

- I did some evil hacks, like saving big images as base64 in localStorage. But it worked!
