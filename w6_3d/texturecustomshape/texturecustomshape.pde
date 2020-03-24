
boolean animate = false;

PImage texture;
float currentOffset = 0;

void setup() {
  size(500, 500, P3D);
  texture = loadImage("waterfall.jpg");
  textureMode(NORMAL); // Normalized UV coordinates (IMAGE is other option)
  textureWrap(REPEAT); // As opposed to CLAMP
}

// Offsets a texture u/v value by a given amount
float offset(float value) {
  if (animate) {
    return value + currentOffset;
  }
  return value;
}

void draw() {
  background(#55ddff);
  
  // rotate scene a bit to show it in 3D
  translate(55, -20, 150);
  rotateY(0.2);
  rotateX(-0.2);

  // Draw cliffside
  fill(#443322);
  rect(0, 145, width, height);

  translate(0,0,1);

  // Draw piece of sky above waterfall
  fill(#55ddff);
  rect(width/2 - 50, 145, 100, 5);

  translate(0,0,1);

  // Draw resevoir
  // NOTE: This draws BEHIND the waterfall despite being drawn first,
  // because its z-value is lower than the bottom of the waterfall.
  fill(#0055bb);
  ellipse(width/2, height, 2*width, 150);

  // Draw waterfall
  pushMatrix();
  translate(width/2 - 50, 150, 0);
  scale(0.5, 0.9, 1);
  noStroke();
  beginShape(TRIANGLE_FAN);
  texture(texture);
  vertex(100, 150, 50,   0.33, offset(0.5));
  vertex(-50, 100, 50,   0, offset(0.25));
  vertex(0, 0, 0,        0, offset(0));
  vertex(200, 0, 0,      0.66, offset(0));
  vertex(250, 100, 50,   1, offset(0.25));
  vertex(250, 300, 100,  1, offset(1));
  vertex(-50, 300, 100,  0, offset(1));
  vertex(-50, 100, 50,   0, offset(0.25));
  endShape();
  popMatrix();

  // Draw circle around cursor to demonstrate depth
  fill(#ffee00);
  translate(mouseX, mouseY, 30);
  ellipse(0,0, 30, 30);

  // Move texture coordinates
  currentOffset = (currentOffset - 0.02) % 1;
}
