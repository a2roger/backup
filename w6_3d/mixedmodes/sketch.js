/*
 * mixed modes demo
 *   Mix of WEBGL 3D and normal 2D p5 rendering modes.
 */

let buffer3D;
let textureBuffer;
let bgImg;

// amount to rotate (in radians)
let r = 0;

function preload() {
  bgImg = loadImage("data/bgImg.jpg");
}

function setup() {
  createCanvas(300, 300);

  textureBuffer = createGraphics(300, 300);
  // need to set the "renderer" to WEBGL
  buffer3D = createGraphics(300, 300, WEBGL);

  // Workaround for bug: https://github.com/processing/p5.js/issues/5634
  // Enables 3D graphics buffers to have transparent background.
  buffer3D.setAttributes("alpha", true);

  noCursor();
}

function storeTexture() {
  textureBuffer.clear();
  textureBuffer.background(255, 12);
  textureBuffer.noStroke();
  textureBuffer.fill(255,0,0);
  textureBuffer.ellipse(mouseX, mouseY, 20, 20);
}

function storeBuffer3D() {
  // IMPORTANT!: Needed in order to clear depth buffer
  buffer3D.clear();

  // Note: Can draw a background here with buffer3D.background(...)
  //    if transparency is not desired.

  // Need push() and pop() here because transformations don't get
  //   reset each frame.
  buffer3D.push();
  // (0,0,0) is at the centre of the canvas
  buffer3D.rotateY(r);
  buffer3D.rotateX(r);
  buffer3D.texture(textureBuffer);
  buffer3D.strokeWeight(3);
  // draw a 100 by 100 by 100 3D cube
  buffer3D.box(100);
  buffer3D.pop();

  r += 0.01;
}

function drawOverlay() {
  noStroke();
  fill(255,224);
  rect(0, 0, 300, 100);
  rect(0, 200, 300, 100);
  image(buffer3D, mouseX-32, mouseY-32, 64, 64);
}

function draw() {
  // Draw background image to demonstrate p5.Graphics transparency
  image(bgImg, 0, 0);

  storeTexture();
  storeBuffer3D();

  // Draw the 3D buffer based on textureBuffer and buffer3D
  image(buffer3D, 0, 0);

  drawOverlay();
}
