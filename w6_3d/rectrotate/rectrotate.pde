
void setup() {
  size(300, 300, P3D);
}

void draw() {
  background(200);
  translate(width/2, height/2, -100);
  // NOTE: These are swapped, because we're rotating AROUND not ALONG these axes
  rotateY(map(mouseX, 0, width, 0, 2*PI));
  rotateX(map(mouseY, 0, height, 0, 2*PI));
  box(100);
} 
