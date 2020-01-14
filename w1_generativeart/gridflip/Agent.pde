
class Agent {

  // line angle (-45 or 45)
  float angle; 

  // location of agent centre and line length
  float x;
  float y;
  float length;

  // create the agent
  Agent(float _x, float _y, float _length) {
    x = _x;
    y = _y;
    length = _length;

    // set initial angle 
    if (random(1) > 0.5) {
      angle = -45;
    } else {
      angle = 45;
    }
  }

  void update() { 
    
  }

  void draw() {
    pushMatrix();
    translate(x, y);
    rotate(radians(angle));
    stroke(0);
    strokeWeight(weight);
    line(0, -length/2, 0, length/2);
    popMatrix();
  }
}
