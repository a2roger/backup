
int mode = 0;

// Rotation coordinates
float rX;
float rY;

// Lighting coordinates
float lX;
float lY;

// Shininess amount
float sX;

void setup() {
  size(300, 300, P3D);
}

void draw() {
  background(0);

  // Apply effect of different modes
  if (mode == 0) {
    rX = mouseX;
    rY = mouseY;
  }

  if (mode == 1 || mode == 3) {
    lX = mouseX;
    lY = mouseY;
  }

  if (mode == 2) {
    sX = mouseX;
  }

  // Configure lighting
  ambientLight(128,128,128);
  lightSpecular(200,200,200);
  pointLight(255,255,255, lX, lY, 0);

  // Draw shape
  fill(128);
  noStroke();
  shininess(map(sX, 0, width, 1, 30));
  pushMatrix();
  translate(width/2, height/2, -100);
  rotateY(map(rX, 0, width, 0, 2*PI));
  rotateX(map(rY, 0, height, 0, 2*PI));
  
  if (mode == 0 || mode == 1) {
    box(100);
  } else{
    sphere(50);
  }
  popMatrix();

  // Draw circle where light is
  fill(255,255,0);
  ellipse(lX, lY, 10, 10);
}

void keyPressed() {
  switch (key) {
    case 'r': mode = 0; break;
    case 'l': mode = (mode == 2) ? 3 : 1; break;
    case 's': mode = 2; break;
    default: break;
  }
} 
