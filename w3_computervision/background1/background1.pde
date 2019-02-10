/* 
 * Background Subtraction using frame differencing
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
PImage background;

//Mat backgroundMat;

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
      background = opencv.getSnapshot();

      // attempt to get native absdiff to work
      //backgroundMat = new Mat(new Size(background.width, background.height), CvType.CV_8UC3);
      //opencv.toCv(background, backgroundMat);
      //Mat m = new Mat(new Size(background.width, background.height), CvType.CV_8UC1);
      //Imgproc.cvtColor(backgroundMat, m, Imgproc.COLOR_BGR2GRAY);
      //backgroundMat = m;
    }    

    // Simple differencing for background subtraction
    if (background != null) {
      opencv.diff(background);

      // attempt to get native absdiff to work
      //Mat m = new Mat(new Size(background.width, background.height), CvType.CV_8UC1);
      //Core.absdiff(opencv.getGray(), backgroundMat, m);
      //opencv.setGray(backgroundMat);

      // threshold to find blobs
      int cutoff = 27; // int(adjustX(0, 255));
      opencv.threshold(cutoff);

      // clean up with morphological operators
      opencv.open(1); //int(adjustY(1, 20)));
      opencv.close(10); //int(adjustX(1, 20)));
    }



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