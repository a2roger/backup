/* 
 * Optical Flow
 *   - set makeDrawing to true to draw a picture with movement
 *
 *    Code based on demos in OpenCV for Processing 0.5.4 
 *    by Greg Borenstein http://gregborenstein.com
 */

import processing.video.*;

import gab.opencv.*;
// also access "native" OpenCV calls
import org.opencv.imgproc.Imgproc;

Capture cam;
OpenCV opencv;

// scale factor to downsample frame for processing 
float scale = 0.5;

// image to display
PImage output;

// dominant direction of image calculated by optical flow
PVector direction;

// the interactive drawing visualization
PGraphics viz;
// last point of the drawing
PVector lastPoint;

boolean makeDrawing = false;

void setup() {
  size(640, 480);

  // want video frame and opencv proccesing to be same size
  cam = new Capture(this, int(640 * scale), int(480 * scale));
  opencv = new OpenCV(this, cam.width, cam.height);

  cam.start();

  // init to empty image
  output = new PImage(cam.width, cam.height);

  lastPoint = new PVector(width/2, height/2);
  direction = new PVector(0, 0);

  viz = createGraphics(width, height);
}

void draw() {
  // clear background to black
  background(0);

  if (cam.available() == true) {
    cam.read();

    // load frame into pipeline 
    opencv.loadImage(cam);

    // mirror
    opencv.flip(1);

    // this calculates the "direction" each cell of an
    // image after it's divided into a grid
    opencv.calculateOpticalFlow();

    // calculate average direction
    direction = opencv.getAverageFlow();

    // if motion is very small, optical flow might return NaN
    // if this happens, just create a 0 vector
    if (Float.isNaN(direction.x) || Float.isNaN(direction.y)) {
      direction = new PVector();
    }

    // grab image of video frame for display
    output = opencv.getSnapshot(); 
  }

  pushMatrix();
  scale(1 / scale);
  tint(255, 128); // partially transparent image
  image(output, 0, 0);
  noTint();

  // draw optical flow vector field for debug
  stroke(255, 128);
  strokeWeight(1);
  opencv.drawOpticalFlow();
  popMatrix();

  // draw direction vector
  stroke(255, 255, 0, 128);
  strokeWeight(4);
  PVector a = new PVector(width/2, height/2);
  PVector b = PVector.add(a, PVector.mult(direction, 50));
  line(a.x, a.y, b.x, b.y);

  // debug output
  fill(255, 0, 0);
  text(nfc(frameRate, 1), 20, 20);

  // the interactove visualization part
  if (makeDrawing) {
    
    // this shows how to draw into an image each frame, 
    // just like drawing into a canvas background
  
    // make the drawing
    //direction = new PVector(1,1);
    PVector nextPoint = PVector.add(lastPoint, PVector.mult(direction, 10));

    // drawing in the PGraphics
    viz.beginDraw();
    viz.stroke(255);
    viz.strokeWeight(4);
    viz.line(lastPoint.x, lastPoint.y, nextPoint.x, nextPoint.y);
    viz.endDraw();

    // paste the viz into the canvas
    image(viz, 0, 0);

    lastPoint = nextPoint;
  }
}


void mousePressed() {
  // click to make a new start location
  lastPoint = new PVector(mouseX, mouseY);
}
