/* 
 * Colour tracking for input
 *
 *    Code based on demos in OpenCV for Processing 0.5.4 
 *    by Greg Borenstein http://gregborenstein.com
 */

import processing.video.*;

import gab.opencv.*;

// also access "native" OpenCV calls
import org.opencv.imgproc.Imgproc;
import org.opencv.core.Core;
import org.opencv.core.Mat;
import org.opencv.core.Size;
import org.opencv.core.CvType;

Capture cam;
OpenCV opencv;

OpenCV frameH;
OpenCV frameS;
OpenCV frameB;

// scale factor to downsample frame for processing 
float scale = 0.5;

PImage debug;

ArrayList<Contour> contours;
ArrayList<Contour> polygons;

// this will be the point we use as a cursor
PVector bodyCursor = new PVector();
PVector pbodyCursor = new PVector(); // previous point

// <1> Set the range of Hue values for our filter
int rangeLow = 20;
int rangeHigh = 60;

// the interactive drawing visualization
PGraphics viz;

boolean makeDrawing = false;

void setup() {
  size(640, 480);

  // want video frame and opencv proccessing to same size
  cam = new Capture(this, int(640 * scale), int(480 * scale));

  opencv = new OpenCV(this, cam.width, cam.height);

  frameH = new OpenCV(this, cam.width, cam.height);
  frameS = new OpenCV(this, cam.width, cam.height);
  frameB = new OpenCV(this, cam.width, cam.height);

  cam.start();

  debug = new PImage(cam.width, cam.height);

  viz = createGraphics(width, height);
}



void draw() {

  if (cam.available() == true) {
    cam.read();

    // load frame into pipeline 
    opencv.loadImage(cam);

    opencv.useColor(RGB);
    opencv.flip(1);
    debug = opencv.getSnapshot(); // grab debug image here

    opencv.useColor(HSB);

    // reduce noise
    Imgproc.medianBlur(opencv.matGray, opencv.matGray, 3);

    // <4> Copy the Hue channel of our image into 
    //     the gray channel, which we process.
    frameH.setGray(opencv.getH().clone());
    frameH.inRange(rangeLow, rangeHigh);

    frameS.setGray(opencv.getS().clone());
    frameS.inRange(50, 255);

    frameB.setGray(opencv.getB().clone());
    frameB.inRange(50, 255);

    opencv.useGray();

    // mask out pixels that satisfy all H, S, and B ranges
    Core.bitwise_and(frameH.matGray, frameB.matGray, opencv.matGray);
    Core.bitwise_and(opencv.matGray, frameS.matGray, opencv.matGray);

    // clean up with morphological operators
    opencv.open(1); //int(adjustY(1, 20)));
    opencv.close(10); //int(adjustX(1, 20)));

    // find top level contours sorted by descending area
    contours = opencv.findContours(false, true);
  }

  pushMatrix();
  scale(1 / scale);
  image(debug, 0, 0 );

  // process the contours here
  if (contours != null && contours.size() > 0) {

    // first one will be largest one
    Contour largestContour = contours.get(0);

    // only use it of it's large
    float minArea = 1000; //adjustX(100, 10000);
    if (largestContour.area() > minArea) {

      // draw contour for debugging
      stroke(255, 255, 0);
      strokeWeight(3);
      largestContour.draw();

      // use largest contour for input
      pbodyCursor = bodyCursor.copy(); // save last position
      bodyCursor = calcCentroid(largestContour.getPoints());
      bodyCursor.mult(1 / scale); // scale to canvas size
    }
  }

  popMatrix();

  if (makeDrawing) {
    viz.beginDraw();
    viz.stroke(255);
    viz.strokeWeight(2);
    viz.line(pbodyCursor.x, pbodyCursor.y, bodyCursor.x, bodyCursor.y);
    viz.endDraw();
    image(viz, 0, 0);
  }

  fill(255, 0, 0);
  text(nfc(frameRate, 1), 20, 20);

  fill(255, 0, 255);
  ellipse(bodyCursor.x, bodyCursor.y, 10, 10);
}

// calculate the centroid (middle) of a sequence of points
PVector calcCentroid( ArrayList<PVector> points) {
  PVector centroid = new PVector(0, 0);
  for (PVector p : points) {
    centroid.add(p);
  }
  centroid.div(points.size());
  return centroid;
}


float adjustX(float low, float high) {
  float v = map(mouseX, 0, width - 1, low, high); 
  println("adjustX: ", v);
  return v;
}

float adjustY(float low, float high) {
  float v = map(mouseY, 0, height - 1, low, high); 
  println("adjustY: ", v);
  return v;
}

void mousePressed() {

  color c = get(mouseX, mouseY);
  println("r: " + red(c) + " g: " + green(c) + " b: " + blue(c));

  int hue = int(map(hue(c), 0, 255, 0, 180));
  println("hue to detect: " + hue);

  rangeLow = hue - 20;
  rangeHigh = hue + 20;
}

void keyPressed() {
   makeDrawing = !makeDrawing;
}
