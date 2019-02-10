
class Agent {

  // current position
  float x, y;
  // previous position
  float px, py;


  // create agent that picks starting position itself
  Agent() {
    // default is all agent are at centre
    x = width / 2;
    y = height / 2;
   
  }

  // create agent at specific starting position
  Agent(float _x, float _y) {
    x = _x;
    y = _y;
  }

  void update() {
    // save last position
    px = x;
    py = y;

    // pick a new position

  }

  void draw() {

    // draw a line between last position
    // and current position
    strokeWeight(1);
    stroke(0, 20);
    line(px, py, x, y);
  }
}