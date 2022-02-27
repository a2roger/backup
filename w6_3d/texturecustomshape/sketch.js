/*
 * texture custom shape demo
 *   Waterfall scene with textured shapes.
 */


const animate = false;

let tex;
let currentOffset = 0;

function preload() {
  tex = loadImage("data/waterfall.jpg");
}

function setup() {
  // need to set the "renderer" to WEBGL
  createCanvas(500, 500, WEBGL);

  textureMode(NORMAL); // Normalized UV coordinates (IMAGE is other option)
  textureWrap(REPEAT); // As opposed to CLAMP or MIRROR
}

// Offsets a texture u/v value by a given amount
function offset(value) {
  if (animate) {
    return value + currentOffset;
  }
  return value;
}

function draw() {
  background("#55ddff");

  noStroke();

  // rotate scene a bit to show it in 3D
  camera(
    -100, -20, 320,
    -30, 30, 0,
    0, 1, 0);

  // Draw circle around cursor to demonstrate depth
  push();
  fill("#ffee00");
  translate(mouseX - width/2, mouseY - height/2, 0);
  ellipse(0,0, 30, 30);
  pop();

  translate(0,0, -30);


  // Draw cliffside
  fill("#443322");
  rect(-width/2, -height/2 + 145, width, height);

  translate(0,0,1);

  // Draw piece of sky above waterfall
  fill("#55ddff");
  rect(-50, -height/2 + 145, 100, 5);

  translate(0,0,1);

  // Draw resevoir
  // NOTE: This draws BEHIND the waterfall despite being drawn first,
  // because its z-value is lower than the bottom of the waterfall.
  fill("#0055bb");
  ellipse(0, height/2, 2*width, 150);

  // Draw waterfall
  push();
  translate(-50, -height/2 + 150, 0);
  scale(0.5, 0.9, 1);
  beginShape(TRIANGLE_FAN);
  texture(tex);
  vertex(100, 150, 50,   0.5, offset(0.5));
  vertex(-50, 100, 50,   0, offset(0.33));
  vertex(0, 0, 0,        0.2, offset(0));
  vertex(200, 0, 0,      0.8, offset(0));
  vertex(250, 100, 50,   1, offset(0.33));
  vertex(250, 300, 100,  1, offset(1));
  vertex(-50, 300, 100,  0, offset(1));
  vertex(-50, 100, 50,   0, offset(0.33));
  endShape();
  pop();

  // Move texture coordinates
  currentOffset = (currentOffset - 0.02) % 1;
}
