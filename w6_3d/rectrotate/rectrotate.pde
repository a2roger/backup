
void setup() {
  // need to set the "renderer" to P3D
  size(300, 300, P3D);
}

void draw() {
  background(200);

  // amount to rotate (in radians)
  float ry = map(mouseX, 0, width, 0, 2*PI);
  float rx = map(mouseY, 0, height, 0, 2*PI);

  // move 0, 0, 0 to centre of canvas
  translate(width/2, height/2, mouseX - 100);
  // NOTE: These are swapped, because we're rotating AROUND not ALONG these axes
  rotateY(ry);
  rotateX(rx);
  // draw a 100 by 100 by 100 3D cube
  box(100);
} 
