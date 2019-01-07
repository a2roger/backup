/*
 * Interactive portrait2: changing playback time
 *  - move the mouse to accelerate playback speed loop, when 
 *    no mouse, speed drops.
 */

// load frames you saved in recorder
// (add more arrays for multiple sets of frames recorded to different folders)
PImage[] frames;

// you can also copy the frames to a subdir of this sketch
String framePath = "../recorder/data/";

void setup() {
  // this is also the size of frame that's saved
  size(256, 256); 

  // load frames (default is 30 frames in recorder data folder)
  frames = loadFrames("../recorder/data/", 30);
}

float index = 0;
float speed = 0.5;
float dir = 1;

void draw() {

  // reverse playback at ends
  // TODO: there's a better way to handle reversing
  if (int(index + speed) >= frames.length || 
    int(index + speed) < 0) {
    dir = -dir;
  }

  // advance index
  index += speed * dir;
  int indexInt = int(constrain(index, 0, frames.length - 1));
  //println(index, indexInt);

  // decelerate
  speed = max(0, speed *= 0.96);

  // 
  image(frames[int(indexInt)], 0, 0);
}

void mouseMoved() {
  // accelerate with speed limit
  speed = min(speed + 0.03, 10);
}

// load in the frames
// filename is 'frame-000.jpg', 'frame-001.jpg', ...
PImage[] loadFrames(String path, int n) {

  PImage[] f = new PImage[n];

  for (int i = 0; i < n; i++) {
    f[i] = loadImage(path + "frame-" + nf(i, 3) + ".jpg");
  } 
  return f;
}