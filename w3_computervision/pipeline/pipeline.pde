/* 
 * OpenCV general pipeline for image processing
 *   - use adjustX and adjustY to tweak parameters
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
    //opencv.blur(ksize);

    // medianBlur aperture must be odd and greater than 1, 
    // for example: 3, 5, 7
    int aperture = int(adjustX(2, 32)) * 2 - 1;
    // shows how to use "native" OpenCV calls
    Imgproc.medianBlur(opencv.getGray(), opencv.getGray(), aperture);

    // histogram equalization (like auto levels in photoshop)
    //Imgproc.equalizeHist(opencv.getGray(), opencv.getGray());

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
    //opencv.close(5);
    //opencv.open(5);
    
    debug = opencv.getSnapshot(); // grab debug image here

  }

  // debug output: image and framerate for now

  pushMatrix();
  // another way to flip the image (when displaying it)
  //translate(width, 0);
  //scale(-1, 1);
  // scale image back up to full canvas
  scale(1 / scale);

  image(debug, 0, 0 );
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
