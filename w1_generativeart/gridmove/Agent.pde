
class Agent {

  // local shape transforms

  // location of agent centre and shape to display
  float x;
  float y;

  float homex;
  float homey;  

  // create the agent
  Agent(float _x, float _y) {
    homex = _x;
    homey = _y;
  }

  void update() {
    float t = random(0.5, 5);
    Ani.to(this, t, "x", random(-randomness, randomness), Ani.QUAD_IN_OUT);
    Ani.to(this, t, "y", random(-randomness, randomness), Ani.QUAD_IN_OUT);
  }

  void draw() {
    pushMatrix();
    translate(x, y);
    translate(homex, homey);
    strokeWeight(5);
    stroke(0);
    noFill();
    ellipse(0, 0, circleSize, circleSize);
    popMatrix();
  }
}