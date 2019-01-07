/*
 * Interactive portrait3: distressed pixels
 *
 *
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
  
  // use first frame as initial background
  image(frames[0], 0, 0);
}

float index = 0;
float speed = 1;
float dir = 1;

void draw() {

  // reverse playback at ends
  if (int(index + speed) >= frames.length || 
    int(index + speed) < 0) {
    dir = -dir;
  }

  // advance index
  index += speed * dir;
  int indexInt = int(constrain(index, 0, frames.length - 1));
  //println(index, indexInt);

  //image(frames[int(indexInt)], 0, 0);
 
  // draw random pixels from current frame based on mouseX position
  for (int i = 0; i < map(mouseX, 0, width, 100, 5000); i++) {
      int x = int(random(width));
      int y = int(random(height));
      color c = frames[indexInt].get(x, y);
      stroke(c);
      point(x, y);
  }
  
  speed = map(mouseY, 0, height, 0, 5);
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