/*
 * box rotate demo
 *   Rotate a 3D box with your mouse.
 */

function setup() {
  // need to set the "renderer" to WEBGL
  createCanvas(300, 300, WEBGL);
}


function draw() {
  background(200);

  // amount to rotate (in radians)
  // NOTE: These are swapped, because we're rotating AROUND not ALONG these axes
  const ry = map(mouseX, 0, width, 0, 2*PI);
  const rx = map(mouseY, 0, height, 0, 2*PI);

  // (0,0,0) is at the centre of the canvas
  rotateY(ry);
  rotateX(rx);
  // draw a 100 by 100 by 100 3D cube
  box(100);
}
