/*
 * video texture demo
 *   A 3D box shows a live video feed.
 */

// video capture
let video;

function setup() {
  // need to set the "renderer" to WEBGL
  createCanvas(300, 300, WEBGL);

  // this sketch will also work similarly with createVideo()
  video = createCapture(VIDEO);
  video.size(640, 480);

  // Hide the video element, and just show the canvas
  video.hide();
}

// amount to rotate (in radians)
let r = 0;

function draw() {
  background(200);

  // (0,0,0) is at the centre of the canvas
  rotateY(r);
  rotateX(r);

  // set the texture to the current video frame
  let img = video.get();
  texture(img);

  // draw a 100 by 100 by 100 3D cube
  noStroke();
  box(100);

  r += 0.01;
}
