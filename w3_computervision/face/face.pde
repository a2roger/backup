/* 
 * Face tracking
 * 
 *    Code based on demos in OpenCV for Processing 0.5.4 
 *    by Greg Borenstein http://gregborenstein.com
 */

import processing.video.*;

import gab.opencv.*;

// to get Java Rectangle type
import java.awt.*; 

Capture cam;
OpenCV opencv;

// scale factor to downsample frame for processing 
float scale = 0.5;

// image to display
PImage output;

// array of bounding boxes for face
Rectangle[] faces;

void setup() {
  size(640, 480);

  // want video frame and opencv proccessing to same size
  cam = new Capture(this, int(640 * scale), int(480 * scale));

  opencv = new OpenCV(this, cam.width, cam.height);
  opencv.loadCascade(OpenCV.CASCADE_FRONTALFACE);  

  cam.start();

  // init to empty image
  output = new PImage(cam.width, cam.height);
}


void draw() {

  if (cam.available() == true) {
    cam.read();

    // load frame into OpenCV 
    opencv.loadImage(cam);

    // it's often useful to mirror image to make interaction easier
    // 1 = mirror image along x
    // 0 = mirror image along y
    // -1 = mirror x and y
    opencv.flip(1);

    faces = opencv.detect();

    // switch to RGB mode before we grab the image to display
    opencv.useColor(RGB);
    output = opencv.getSnapshot(); 
  }

  // draw the image
  pushMatrix();
  scale(1 / scale); // inverse of the downsample scale
  image(output, 0, 0 );
  popMatrix();

  // draw face tracking debug
  if (faces != null) {
    for (int i = 0; i < faces.length; i++) {

      // scale the tracked faces to canvas size
      float s = 1 / scale;
      int x = int(faces[i].x * s);
      int y = int(faces[i].y * s);
      int w = int(faces[i].width * s);
      int h = int(faces[i].height * s);

      // draw bounding box and a "face id"
      stroke(255, 255, 0);
      noFill();     
      rect(x, y, w, h);
      fill(255, 255, 0);
      text(i, x, y - 20);
    }
  }

  fill(255, 0, 0);
  // nfc is a function to format numbers, second argument is 
  // number of decimal places to show
  text(nfc(frameRate, 1), 20, 20);
}
