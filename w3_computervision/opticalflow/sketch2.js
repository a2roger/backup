// closely based on:
// https://kylemcdonald.github.io/cv-examples/

var capture;
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
let direction

let makeDrawing = true;



function setup() {
    createCanvas(w, h);
    capture = createCapture({
        audio: false,
        video: {
            width: w,
            height: h
        }
    }, function () {
        console.log('capture ready.')
    });

    capture.elt.setAttribute('playsinline', '');
    capture.hide();

    flow = new FlowCalculator(step);

    lastPoint = new p5.Vector(width / 2, height / 2)
    direction = new p5.Vector(0, 0)

    viz = createGraphics(width, height);
}

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

function draw() {


    capture.loadPixels();

    if (capture.pixels.length > 0) {
        if (previousPixels) {

            // cheap way to ignore duplicate frames
            if (same(previousPixels, capture.pixels, 16, width)) {
                return;
            }

            flow.calculate(previousPixels, capture.pixels, capture.width, capture.height);
        }

        previousPixels = copyImage(capture.pixels, previousPixels);

        image(capture, 0, 0, w, h);

        if (flow.flow && flow.flow.u != 0 && flow.flow.v != 0) {
            strokeWeight(2);
            flow.flow.zones.forEach(function (zone) {
                stroke(128)
                // stroke(map(zone.u, -step, +step, 0, 255),
                //        map(zone.v, -step, +step, 0, 255), 128);
                line(zone.x, zone.y, zone.x + zone.u, zone.y + zone.v);
            })

            direction = new p5.Vector(flow.flow.u, flow.flow.v)

            stroke(255)
            strokeWeight(2)
            let s = 10.0
            push()
            translate(width / 2, height / 2)
            line(0, 0, flow.flow.u * s, flow.flow.v * s)
            pop()
        }
    }


    filter(GRAY)

    // the interactive visualization part
    if (makeDrawing) {

        // this shows how to draw into an image each frame, 
        // just like drawing into a canvas background

        // make the drawing
        // direction = new p5.Vector(1,1);
        nextPoint = p5.Vector.add(lastPoint, p5.Vector.mult(direction, 1.0));
        // nextPoint = new p5.Vector(10, 10)

        // drawing in the PGraphics
        // viz.beginDraw();
        viz.stroke(255);
        viz.strokeWeight(4);
        viz.line(lastPoint.x, lastPoint.y, nextPoint.x, nextPoint.y);
        // viz.endDraw();

        // paste the viz into the canvas
        image(viz, 0, 0);

        lastPoint = nextPoint;
    }
}

function mousePressed() {
 // click to make a new start location
  lastPoint = new p5.Vector(mouseX, mouseY);
}