class Agent {
  // agent centre and line length
  x;
  y;
  length;

  // line angle (-45 or 45)
  angle;

  constructor(x, y, length) {
    this.x = x;
    this.y = y;
    this.length = length;

    // set initial angle
    if (random(1) > 0.5) {
      this.angle = -45;
    } else {
      this.angle = 45;
    }
  }

  update() {
    if (frameRate() > 0 && random(1) < p.flipChance / 100 / frameRate()) {
      let a = -45;
      if (this.angle < 0) {
        a = 45;
      }

      tick.play();
      gsap.to(this, { angle: a, duration: 2, ease: "elastic.out(1.3, 0.3)" });
    }
  }

  draw() {
    push();
    translate(this.x, this.y);
    rotate(radians(this.angle));
    stroke(0);
    strokeWeight(p.weight);
    line(0, -this.length / 2, 0, this.length / 2);
    pop();
  }
}
