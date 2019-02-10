
class Agent {

  // local shape transforms
  float scale = 1;
  float angle = 0; 

  // location of agent centre and shape to display
  float x;
  float y;
  PShape shape;

  // create the agent
  Agent(float _x, float _y, PShape _shape) {
    x = _x;
    y = _y;
    shape = _shape;
  }

  void update() {

    // calculate angle between mouse position and actual position of the shape
    angle = degrees(atan2(mouseY - y, mouseX - x));
    
    // calculate distance from mouse to shape and use it to adjust scale
    float d = dist(mouseX, mouseY, x, y);
    scale = map(d, 0, maxDist, 1, distScale);
  }

  void draw() {
    pushMatrix();
    translate(x, y);
    rotate(radians(shapeAngle + angle));
    noStroke();
    noFill();    
    shapeMode(CENTER);
    float s = scale * shapeScale * 50;
    shape(shape, 0, 0, s, s);
    popMatrix();
  }
}
