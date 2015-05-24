---
title: Sir Sierpinski - PIXI.js Demo
summary: This is an implemenation of Sierpinski Triangles using Pixi.js.
---


<script data-slug-hash="Gflmy" data-user="jorin" data-height="400" data-default-tab="result" data-theme-id="8862" class='codepen' async src="//codepen.io/assets/embed/ei.js" ></script>

The only really reason you create something with `<canvas>` is performance (think games).
For almost all other 2D graphics you better use SVG.
If you want speed WebGL ist even better.
Luckily [PIXI.js](http://www.pixijs.com/) uses WebGL with Canvas fallback so you don't have to worry about bad browser support and difficult APIs.
And it works pretty well.
Checkout out this demo. It re-calculates and re-draws this whole graphic every frame and still appears smooth.
And as you can see the API is pretty straight forward.
