
class Agent {
  PVector p, pOld;
  float stepSize, angle;
  boolean isOutside = false;

  Agent() {
    p = new PVector(random(width), random(height));
    pOld = new PVector(p.x, p.y);
    stepSize = random(1, 5);
  }

  void update1() {

    pOld.set(p);
    isOutside = false;

    angle = noise(p.x/noiseScale, p.y/noiseScale) * noiseStrength;

    p.x += cos(angle) * stepSize;
    p.y += sin(angle) * stepSize;

    if (p.x < -10) isOutside = true;
    else if (p.x > width + 10) isOutside = true;
    else if (p.y < -10) isOutside = true;
    else if (p.y > height + 10) isOutside = true;

    if (isOutside) {
      p.x = random(width);
      p.y = random(height);
      pOld.set(p);
    }
  }

  void update2() {

    pOld.set(p);
    isOutside = false;

    angle = noise(p.x/noiseScale, p.y/noiseScale) * 24;
    angle = (angle - int(angle)) * noiseStrength;

    p.x += cos(angle) * stepSize;
    p.y += sin(angle) * stepSize;

    if (p.x<-10) isOutside = true;
    else if (p.x>width+10) isOutside = true;
    else if (p.y<-10) isOutside = true;
    else if (p.y>height+10) isOutside = true;

    if (isOutside) {
      p.x = random(width);
      p.y = random(height);
      pOld.set(p);
    }
  }

  void draw() {
    strokeWeight(strokeWidth*stepSize);
    line(pOld.x, pOld.y, p.x, p.y);
  }
}