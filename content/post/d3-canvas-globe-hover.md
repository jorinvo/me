---
date: 2017-02-02T17:20:45+01:00
summary: |
  D3 is an excellent tool to visalize geo data.
  See how to implement a simple example.
title: Create a 3D globe with D3.js
---

If you every need to visualize some geo data, [D3.js](https://d3js.org) is an excellent tool for this.

There are libraries and examples out there to do all (or at least most) things you can imagine.

I used it to create a 3D draggable globe including interaction with countries.

My code is built on this [great example](https://bl.ocks.org/mbostock/7ea1dde508cec6d2d95306f92642bc42) for implementing smooth dragging.

The only tricky part was figuring out how to interact with a clicked or hovered country.
My first attempt was using SVG for rendering and do the event handling like you would do with other DOM elements.
However there are clear performance differences between SVG and canvas rendering - especially with auto-rotation.

The working solution uses an algorithm borrowed from [d3-polygon](https://github.com/d3/d3-polygon) to check
if the current cursor position is inside the polygons of a country.

<br>

<p data-height="540" data-theme-id="light" data-slug-hash="YNajXZ" data-default-tab="result" data-user="jorin" data-embed-version="2" data-pen-title="D3 canvas globe with country hover" class="codepen">See the Pen <a href="https://codepen.io/jorin/pen/YNajXZ/">D3 canvas globe with country hover</a> by jorin (<a href="https://codepen.io/jorin">@jorin</a>) on <a href="https://codepen.io">CodePen</a>.</p>
<script async src="https://production-assets.codepen.io/assets/embed/ei.js"></script>
