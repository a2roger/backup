
class Agent {

  // current position
  float x;
  float y;

  // curve parameters
  float l = 1;
  float t;

  // stroke weight and shade
  float weight; 
  float shade;
  float hue;


  // create a new agent
  Agent() {
    reset();
  }

  void update() {

    float px = x;
    float py = y;

    l += random(-maxStep, maxStep);
    x = x + l * cos(t);
    y = y + l * sin(t);

    line(px, py, x, y);

    t += probTurn;

    // draw the line
    strokeWeight(weight);
    stroke(hue, 100, shade, 33);
    line(px, py, x, y);

    // reset the agent if it leaves the canvas
    if (x < 0 || x > width - 1 || y < 0 || y > height - 1) {
      reset();
    }

    // reset the agent if it gets too big
    if (weight > 0.25 * height) {
      reset();
    }
  }

  void reset() {
    float m = 0.02 * height; // margin
    x = random(m, width - m);
    y = random(m, height - m);
    t = random(TWO_PI);
    shade = random(0, 255);
    weight = 1;


    // pick a hue
    hue = (baseHue + random(0, 60)) % 360;
  }

  void draw() {
  }
}