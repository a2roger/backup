/*
 * simple model demo
 *   Rotate a loaded 3D model with your mouse.
 */

let mesh;

function preload() {
  mesh = loadModel("data/tinker.obj");
}

function setup() {
  // need to set the "renderer" to WEBGL
  createCanvas(300, 300, WEBGL);
}

function draw() {
  background(100);
  lights();

  // amount to rotate (in radians)
  // NOTE: These are swapped, because we're rotating AROUND not ALONG these axes
  const ry = map(mouseX, 0, width, 0, 2*PI);
  const rx = map(mouseY, 0, height, 0, 2*PI);

  translate(0, 0, 200);
  rotateY(ry);
  rotateX(rx);

  // draw 3D mesh
  noStroke();
  model(mesh);
}
