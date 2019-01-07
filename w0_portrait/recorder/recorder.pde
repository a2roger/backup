/*
 * Records video frames to use in the portrait sketch 
 *  - window into video is positioned by dragging the mouse
 *  - press SPACE to save a frame (hold to save sequence of frames)
 *
 */
 
 // directory to save frames to 
// (change path to capture multiple sequences)
String savePath = "data2/";

// number of frames to save
int saveNum = 30; 

import processing.video.*;

// video capture object
Capture cam;

// size of video capture frame 
// (note that only part will be visible in canvas)
int captureWidth = 640;
int captureHeight = 480;

// offset for positioning the camera frame
int offsetX = 0;
int offsetY = 0;

// variable to keep track of save progress
int saveCount = 0; // count of frames that are saved
boolean saveNext = false; // flag to save next frame
int videoFrame = 0; // track video frames received
int savedvideoFrame = -1; // last video frame that was saved


void setup() {
  // this is also the size of frame that's saved
  size(256, 256);

  // uncomment this to get list of cameras 
  // (program will exit after, you then need to put your camera 
  // into the code to open a camera below)
  //getCameraList();

  // Examples of how to open a camera based on the list
  // OPTION 1: Give specific resolution, name, framerate
  // cam = new Capture(this, 640, 480, "Built-in iSight", 30);
  // OPTION 2: Give resolution only (will just get defualt)
  // cam = new Capture(this, 640, 480); 
  // OPTION 3: Get list of cameras, then use one from list
  // String[] cameras = Capture.list();
  // cam = new Capture(this, cameras[15]);

  // open your camera here using one of the options
  cam = new Capture(this, captureWidth, captureHeight);
  //cam = new Capture(this, captureWidth, captureHeight, "FaceTime HD Camera (Display)", 15);
  // start the capture once it's opened
  cam.start();
  
  // lowering framerate might make capture easier
  frameRate(30);
}



void draw() {
  // get frame
  if (cam.available() == true) {
    cam.read();

    // keep track of video frames
    videoFrame++;

    // position frame in canvas
    image(cam, offsetX, offsetY, captureWidth, captureHeight);

    // if saving a video frame
    if (saveNext) {

      // save the frame (nf just adds leading zeros)
      save(savePath + "frame-" + nf(saveCount, 3) + ".jpg");

      // increment save frame count
      saveCount++;

      // reset the flag
      saveNext = false;
    }

    // frame count to see what's been saved so far
    text(saveCount + "/" + saveNum, 20, 20);
  }
}

void keyPressed() {

  // save when SPACE is pressed, 
  // but don't save same frame twice and only so many frames
  if (key == ' ' && 
    saveCount < saveNum) {
    saveNext = true;
  }
}

// position video to capture
void mouseDragged() {
  offsetX += mouseX - pmouseX;
  offsetY += mouseY - pmouseY;

  // prevent video frame from being dragged outside canvas
  offsetX = constrain(offsetX, width - captureWidth, 0);
  offsetY = constrain(offsetY, height - captureHeight, 0);
}


void getCameraList() {

  // this sometimes hangs, so make sure "done" eventually appears
  print("Getting list of cameras ... ");
  String[] cameras = Capture.list();
  println("done");

  if (cameras == null) {
    println("Failed to retrieve the list of available cameras, will try the default...");
  } else if (cameras.length == 0) {
    println("There are no cameras available for capture.");
  } else {
    println("Available cameras:");
    printArray(cameras);
  }

  // exit after getting list
  // (you need to put a specific camera in the setup code above)
  exit();
}
