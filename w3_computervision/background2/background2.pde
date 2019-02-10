/* 
 * Background Subtraction using frame MOG
 */

import processing.video.*;

import gab.opencv.*;

// also access "native" OpenCV calls
import org.opencv.imgproc.Imgproc;

Capture cam;
OpenCV opencv;

// scale factor to downsample frame for processing 
float scale = 0.5;

PImage debug;

void setup() {
  size(640, 480);

  // want video frame and opencv proccesing to same size
  cam = new Capture(this, int(640 * scale), int(480 * scale));
  opencv = new OpenCV(this, cam.width, cam.height);

  cam.start();

  debug = new PImage(cam.width, cam.height);

  startBackground();
}



void startBackground() {

  // history – Length of the history.
  // nmixtures – Number of Gaussian mixtures.
  // backgroundRatio – how fast forground objects blend into background
  opencv.startBackgroundSubtraction(5, 3, 0.0001);
}

void draw() {

  if (cam.available() == true) {
    cam.read();

    // load frame into pipeline 
    opencv.loadImage(cam);

    // mirror
    opencv.flip(1);

    // reduce noise
    Imgproc.medianBlur(opencv.matGray, opencv.matGray, 3);

    // use frame as background
    if (keyPressed) {
      startBackground();
    }    

    // MOG Background Subtraction
    opencv.updateBackground();

    // clean up with morphological operators
    opencv.open(1); //int(adjustY(1, 20)));
    opencv.close(5); //int(adjustX(1, 20)));
    
    debug = opencv.getSnapshot(); // grab debug image here
  }

  // debug output
  pushMatrix();
  scale(1 / scale);
  image(debug, 0, 0 );
  popMatrix();

  fill(255, 0, 0);
  text(nfc(frameRate, 1), 20, 20);
}


float adjustX(float low, float high) {
  float v = map(mouseX, 0, width - 1, low, high); 
  println("adjustX: ", v);
  return v;
}
