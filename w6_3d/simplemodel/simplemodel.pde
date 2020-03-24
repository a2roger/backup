
PShape mesh;

void setup() {
  size(300, 300, P3D);
  mesh = loadShape("tinker.obj");
}

void draw() {
  background(200);
  lights();

  // amount to rotate (in radians)
  // NOTE: These are swapped, because we're rotating AROUND not ALONG these axes
  float ry = map(mouseX, 0, width, 0, 2*PI);
  float rx = map(mouseY, 0, height, 0, 2*PI);

  // move 0, 0, 0 to centre of canvas
  translate(width/2, height/2, 200);
  rotateY(ry);
  rotateX(rx);
  
  // draw 3D mesh
  shape(mesh);
} 
