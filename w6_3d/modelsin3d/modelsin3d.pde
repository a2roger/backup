
PShape tree;
PImage alternateTexture;

boolean drawMultiple = false;

void setup() {
  size(800, 400, P3D);
  tree = loadShape("tree.obj");
  alternateTexture = loadImage("tree_texture_alternate.jpg");
}

// Draws one tree with the correct scale and rotation
void drawTree() {
  pushMatrix();
  scale(30);
  rotateZ(PI);
  shape(tree);
  popMatrix();
}

void draw() {
  background(128, 200, 255);
  
  noStroke();
  fill(100, 150, 50);
  rect(0, 3*height/4, width, height/4);
  
  translate(width/2, 3*height/4, 0);
  if (!drawMultiple) {
    drawTree();
  } else {
    for (int i = -5; i < 5; i++) {
      pushMatrix();
      translate(i*50, 0, noise(i)*200);
      drawTree();
      popMatrix();
    }
  }
}

void keyPressed() {
  if (key == 'c') {
    tree.setTexture(alternateTexture);
  }
  if (key == 'm') {
    drawMultiple = !drawMultiple;
  }
}
