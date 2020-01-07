/*
 * Interactive portrait1: mouse triggers frames
 *  - move mouse horizontally to display corresponding frame
 *  - press any key to start and stop GIF save
 */

// load frames you saved in recorder
// (add more arrays for multiple sets of frames recorded to different folders)
PImage[] frames;

void setup() {
  // this is also the size of frame that's saved
  size(256, 256); 

  // load frames (default is 30 frames in recorder data folder)
  frames = loadFrames("../recorder/data/", 30);
}

void draw() {
  // transform mouseX position into frame index
  int i = floor(map(mouseX, 0, width - 1, 0, frames.length - 1));

  image(frames[i], 0, 0);
  
  // see if a gif frame should be saved
  gifSave(1);
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


// Code for Making Gifs
// (just copy and paste this to the bottom of your sketch and call
// gifSave in draw like above)

// Don't install using "Sketch/Add Library...", you must do a 
// manual installtion from the URL below. 
// https://github.com/extrapixel/gif-animation/tree/3.0
import gifAnimation.*; 
GifMaker gifExport;

int frame;
boolean saveGif = false;

void gifSave(int delay) {
  if (saveGif) {
    frame++;
    print(frame, " ");
    gifExport.setDelay(delay);
    gifExport.addFrame();
  }
}

void keyPressed() {
  if (gifExport == null && !saveGif) {
    gifExport = new GifMaker(this, "me.gif");
    gifExport.setRepeat(0);
    saveGif = true;
    frame = 0;
    println("Start gif export");
  } else if (saveGif) {
    gifExport.finish();  
    saveGif = false;
    println("\nEnd gif export");
  }
}
