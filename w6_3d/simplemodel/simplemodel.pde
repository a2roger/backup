
PShape mesh;

void setup() {
  size(800, 400, P3D);
  mesh = loadShape("tinker.obj");
}

void draw() {
  background(200);
  
  lights();

  // amount to rotate (in radians)
  float ry = map(mouseX, 0, width, 0, 2*PI);
  float rx = map(mouseY, 0, height, 0, 2*PI);

  // move 0, 0, 0 to centre of canvas
  translate(width/2, height/2, mouseX - 100);
  // NOTE: These are swapped, because we're rotating AROUND not ALONG these axes
  rotateY(ry);
  rotateX(rx);
  
  // draw 3D mesh
  pushMatrix();
  scale(3);
  shape(mesh);
  popMatrix();
} 
