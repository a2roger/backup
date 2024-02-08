// closely based on:
// https://kylemcdonald.github.io/cv-examples/

var video;
var previousPixels;
var flow;
var w = 640,
  h = 480;
var step = 8;

// the interactive drawing visualization
let viz;
// last point of the drawing
let lastPoint;
// current direction
let direction;

let makeDrawing = false;

function setup() {
  createCanvas(w, h);

  video = createCapture(VIDEO);
  video.size(width, height);

  video.hide();

  // optical flow setup
  flow = new FlowCalculator(step);
  // save the overall direction vector in here
  direction = new p5.Vector(0, 0);

  // for drawing demo only
  lastPoint = new p5.Vector(width / 2, height / 2);
  viz = createGraphics(width, height);
}

function draw() {
  video.loadPixels();

  if (video.pixels.length > 0) {
    if (previousPixels) {
      // cheap way to ignore duplicate frames
      if (same(previousPixels, video.pixels, 8, width)) {
        return;
      }
      flow.calculate(
        previousPixels,
        video.pixels,
        video.width,
        video.height
      );
    }

    previousPixels = copyImage(video.pixels, previousPixels);

    tint(100, 200);
    image(video, 0, 0, w, h);
    noTint();

    if (flow.flow && flow.flow.u != 0 && flow.flow.v != 0) {
      // draw the flow in each zone
      strokeWeight(2);
      flow.flow.zones.forEach(function (zone) {
        stroke(128);
        // stroke(map(zone.u, -step, +step, 0, 255),
        //        map(zone.v, -step, +step, 0, 255), 128);
        line(zone.x, zone.y, zone.x + zone.u, zone.y + zone.v);
      });

      // get overall flow
      direction = new p5.Vector(flow.flow.u, flow.flow.v);

      // draw direction vector in middle
      stroke(255);
      strokeWeight(2);
      let s = 10.0;
      push();
      translate(width / 2, height / 2);
      line(0, 0, flow.flow.u * s, flow.flow.v * s);
      pop();
    }
  }

  // make bg more subtle
  // filter(GRAY)

  // the interactive visualization part
  if (makeDrawing) {
    // this shows how to draw into an image each frame,
    // just like drawing into a canvas background

    // make the drawing
    nextPoint = p5.Vector.add(
      lastPoint,
      p5.Vector.mult(direction, 1.0)
    );

    // drawing in the PGraphics
    viz.stroke(255);
    viz.strokeWeight(4);
    viz.line(lastPoint.x, lastPoint.y, nextPoint.x, nextPoint.y);

    // paste the viz into the canvas
    image(viz, 0, 0);

    lastPoint = nextPoint;
  }
}

function mousePressed() {
  // click to make a new start location
  lastPoint = new p5.Vector(mouseX, mouseY);
}

// helper functions for optical flow

function copyImage(src, dst) {
  var n = src.length;
  if (!dst || dst.length != n) dst = new src.constructor(n);
  while (n--) dst[n] = src[n];
  return dst;
}

function same(a1, a2, stride, n) {
  for (var i = 0; i < n; i += stride) {
    if (a1[i] != a2[i]) {
      return false;
    }
  }
  return true;
}
