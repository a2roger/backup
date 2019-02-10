/* 
 * Contours
 * 
 *    Code based on demos in OpenCV for Processing 0.5.4 
 *    by Greg Borenstein http://gregborenstein.com
 */


import processing.video.*;

import gab.opencv.*;
// also access "native" OpenCV calls
import org.opencv.imgproc.Imgproc;

import java.awt.Rectangle;


Capture cam;
OpenCV opencv;

// scale factor to downsample frame for processing 
float scale = 0.5;

ArrayList<Contour> contours;
ArrayList<Contour> polygons;

void setup() {
  size(640, 480);

  // want video frame and opencv proccesing to same size
  cam = new Capture(this, int(640 * scale), int(480 * scale));
  opencv = new OpenCV(this, cam.width, cam.height);

  cam.start();

  debug = new PImage(cam.width, cam.height);
}

PImage debug;

void draw() { 

  if (cam.available() == true) {
    cam.read();

    // load frame into pipeline 
    opencv.loadImage(cam);

    // mirror
    opencv.flip(1);

    // blurring kernel size
    //int ksize = int(adjustY(1, 30));
    int ksize = 3;
    opencv.blur(ksize);

    // medianBlur aperture must be odd and greater than 1, 
    // for example: 3, 5, 7
    int aperture = 3; //int(adjustX(2, 32)) * 2 - 1;
    // shows how to use "native" OpenCV calls
    Imgproc.medianBlur(opencv.getGray(), opencv.getGray(), aperture);

    // histogram equalization (like auto levels in photoshop)
    Imgproc.equalizeHist(opencv.getGray(), opencv.getGray());

    debug = opencv.getSnapshot(); // grab debug image here

    // you may want to invert the image here, only the white spots
    // will be recognized as contours
    opencv.invert();

    // threshold cutoff is between 0 and 255
    int cutoff = int(adjustY(0, 255));
    opencv.threshold(cutoff);

    // blocksize (must be odd number greater than 3), c (can be negative)
    int blocksize = 11; //int(adjustX(2, 32)) * 2 - 1;
    int c = 0; //int(adjustY(-10, 10));
    //opencv.adaptiveThreshold(blocksize, c);

    // morphological operations (useful for cleaning up noisy image masks)
    //opencv.dilate();
    //opencv.erode();
    opencv.close(int(adjustX(1, 20)));
    //opencv.open(5);

    // find contours sorted by descending area
    // set param 1 to true to find nested contours (holes in blobs)
    // set param 2 to true to return contours sorted by descending area
    contours = opencv.findContours(false, true);
  }

  // debug output: image and framerate for now

  pushMatrix();
  // another way to flip the image (when displaying it)
  //translate(width, 0);
  //scale(-1, 1);
  // scale image back up to full canvas
  scale(1 / scale);

  image(debug, 0, 0 );

  // display call contours here
  if (contours != null) {

    for (int i = 0; i < contours.size(); i++) {
      Contour c = contours.get(i);

      // only use it of it's large
      float minArea = 100; //adjustX(100, 10000);
      if (c.area() > minArea) {

        // draw contour for debugging

        // full contour in yellow
        strokeWeight(2);
        stroke(255, 255, 0);
        fill(255, 255, 0, 50);
        c.draw();

        noFill();
        strokeWeight(1);

        // approximated contour in red
        Contour cApprox = c.getPolygonApproximation();
        stroke(255, 0, 0);
        cApprox.draw();
        
        // convext full in green
        Contour cConvex = c.getConvexHull();
        stroke(0, 255, 0);
        cConvex.draw();      
        
        // bounding box in blue
        Rectangle boundingBox = c.getBoundingBox();
        stroke(0, 0, 255);
        rect(boundingBox.x, boundingBox.y, boundingBox.width, boundingBox.height);
        
      }
    }
  }

  popMatrix();

  fill(255, 0, 0);
  text(nfc(frameRate, 1), 20, 20);
}



// helper functions to adjust values with mouse

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