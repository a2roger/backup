/* 
 * Glitch art (at least on my MacOS machine)
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
}

void draw() {

  if (cam.available() == true) {
    cam.read();
    opencv.loadImage(cam);
    // I think this is just creating an image out of existing memory
    Mat m = new Mat(new Size(opencv.width, opencv.height), CvType.CV_8UC1);      
    opencv.setGray(m);
    scale(1 / scale);
    image(opencv.getSnapshot(), 0, 0 );
  }
}