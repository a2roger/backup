
class Agent {

  // local shape transforms

  // location of agent centre
  int x;
  int y;
  
  // pixel location in image
  int px;
  int py;
  
  float greyscale;
  color pixelColour;

  // create the agent
  Agent(float _x, float _y, int _px, int _py) {
    x = (int)_x;
    y = (int)_y;
    px = _px;
    py = _py;
  }

  void update() {

    // get current color
    pixelColour = img.pixels[py * img.width + px];
    // greyscale conversion
    greyscale = round(red(pixelColour)*0.222+green(pixelColour)*0.707+blue(pixelColour)*0.071);
    //println(x, y, px, py, greyscale);
  }

  void draw() {

    float tileWidth = width / (float)img.width;
    float tileHeight = height / (float)img.height;

    switch(drawMode) {

    case 1:
      // greyscale to stroke weight
      float w1 = map(greyscale, 0, 255, 15, 0.1);
      stroke(0);
      strokeWeight(w1 * xfactor);
      line(x, y, x+5, y+5); 
      break;

    case 2:
      // greyscale to ellipse area
      fill(0);
      noStroke();
      float r2 = 1.1284 * sqrt(tileWidth*tileWidth*(1-greyscale/255.0));
      r2 = r2 * xfactor * 3;
      ellipse(x, y, r2, r2);
      break;

    case 3:
      // greyscale to line length
      float l3 = map(greyscale, 0, 255, 30, 0.1);
      l3 = l3 * xfactor;   
      stroke(0);
      strokeWeight(10 * yfactor);
      line(x, y, x+l3, y+l3);
      break;

    case 4:
      // greyscale to rotation, line length and stroke weight
      stroke(0);
      float w4 = map(greyscale, 0, 255, 10, 0);
      strokeWeight(w4 * xfactor + 0.1);
      float l4 = map(greyscale, 0, 255, 35, 0);
      l4 = l4 * yfactor;
      pushMatrix();
      translate(x, y);
      rotate(greyscale/255.0 * PI);
      line(0, 0, 0+l4, 0+l4);
      popMatrix();
      break;

    //case 5:
    //  // greyscale to line relief
    //  float w5 = map(greyscale, 0, 255, 5, 0.2);
    //  strokeWeight(w5 * yfactor + 0.1);
    //  // get neighbour pixel, limit it to image width
    //  color c2 = img.get(min(gridX+1, img.width-1), gridY);
    //  stroke(c2);
    //  int greyscale2 = int(red(c2)*0.222 + green(c2)*0.707 + blue(c2)*0.071);
    //  float h5 = 50 * xfactor;
    //  float d1 = map(greyscale, 0, 255, h5, 0);
    //  float d2 = map(greyscale2, 0, 255, h5, 0);
    //  line(x-d1, y+d1, x+tileWidth-d2, y+d2);
    //  break;

    case 6:
      // pixel color to fill, greyscale to ellipse size
      float w6 = map(greyscale, 0, 255, 25, 0);
      noStroke();
      fill(pixelColour);
      ellipse(x, y, w6 * xfactor, w6 * xfactor); 
      break;

    case 7:
      stroke(pixelColour);
      float w7 = map(greyscale, 0, 255, 5, 0.1);
      strokeWeight(w7);
      fill(255, 255* xfactor);
      pushMatrix();
      translate(x, y);
      rotate(greyscale/255.0 * PI* yfactor);
      rect(0, 0, 15, 15);
      popMatrix();
      break;

    case 8:
      noStroke();
      fill(greyscale, greyscale * xfactor, 255* yfactor);
      rect(x, y, 3.5, 3.5);
      rect(x+4, y, 3.5, 3.5);
      rect(x, y+4, 3.5, 3.5);
      rect(x+4, y+4, 3.5, 3.5);
      break;

    case 9:
      stroke(255, greyscale, 0);
      noFill();
      pushMatrix();
      translate(x, y);
      rotate(greyscale/255.0 * PI);
      strokeWeight(1);
      rect(0, 0, 15* xfactor, 15* yfactor);
      float w9 = map(greyscale, 0, 255, 15, 0.1);
      strokeWeight(w9);
      stroke(0, 70);
      ellipse(0, 0, 10, 5);
      popMatrix();
      break;
    }
  }
}