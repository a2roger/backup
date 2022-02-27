/*
 * pyramid shape demo
 *   Construct a 3D pyramid from scratch.
 */

// Base triangle size
const s = 100;

function setup() {
  // need to set the "renderer" to WEBGL
  createCanvas(300, 300, WEBGL);
}

function draw() {
  background(200);

  translate(0, 0, -100);
  // NOTE: These are swapped, because we're rotating AROUND not ALONG these axes
  rotateY(map(mouseX, 0, width, 0, 2*PI));
  rotateX(map(mouseY, 0, height, 0, 2*PI));
  // Uncomment to move triangle origin
  //translate(-s/2, -s/2, 0);

  beginShape(TRIANGLES);

  // base

  vertex(0,0,0);
  vertex(0,s,0);
  vertex(s,0,0);

  vertex(0,s,0);
  vertex(s,s,0);
  vertex(s,0,0);

  // sides

  vertex(0,0,0);
  vertex(s,0,0);
  vertex(s/2, s/2, s);

  vertex(0,0,0);
  vertex(0,s,0);
  vertex(s/2, s/2, s);

  vertex(0,s,0);
  vertex(s,s,0);
  vertex(s/2, s/2, s);

  vertex(s,0,0);
  vertex(s,s,0);
  vertex(s/2, s/2, s);

  endShape();
}
