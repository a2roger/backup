import processing.sound.*;
SoundFile[] file;
Reverb[] verb;
Gui gui;

// Define the number of samples 
int numsounds = 5;

int value[] = {0, 0, 0};
float Room = 0.5;
float Wet = 0.2;

void setup() {
  size(640, 360);
  background(255);
  colorMode(HSB, 360, 100, 100);
  
  // Create a Sound renderer and an array of empty soundfiles
  file = new SoundFile[numsounds];
  verb = new Reverb[numsounds];

  // Load 5 sounds in data. 
  for (int i = 0; i < numsounds; i++) {
    file[i] = new SoundFile(this, (i+1) + ".aif");
    verb[i] = new Reverb(this);
    verb[i].process(file[i]);
  }

  // setup the simple Gui
  gui = new Gui(this);

  gui.addSlider("Room", 0, 1.2);
  gui.addSlider("Wet", 0, 1.2);
}

void draw() {
  background(value[0], 100, 100);
}



void keyPressed() {
  for (int i=0; i < 3; i++) {  
    value[i]=int(random(270, 300));
  }

  switch(key) {
  case 'a':
    file[0].play(0.5, 1.0);
    break;

  case 's':
    file[1].play(0.5, 1.0);
    break;

  case 'd':
    file[2].play(0.5, 1.0);
    break;

  case 'f':
    file[3].play(0.5, 1.0);
    break;

  case 'g':
    file[4].play(0.5, 1.0);
    break;

  case 'h':
    file[0].play(1.0, 1.0);
    break;

  case 'j':
    file[1].play(1.0, 1.0);
    break;

  case 'k':
    file[2].play(1.0, 1.0);
    break;

  case 'l':
    file[3].play(1.0, 1.0);
    break;

  case 'w':
    file[4].play(1.0, 1.0);
    break;

  case 'e':
    file[0].play(2.0, 1.0);
    break;

  case 'r':
    file[1].play(2.0, 1.0);
    break;

  case 't':
    file[2].play(2.0, 1.0);
    break;    

  case 'y':
    file[3].play(2.0, 1.0);
    break;

  case 'u':
    file[4].play(2.0, 1.0);
    break; 

  case 'i':
    file[0].play(3.0, 1.0);
    break;

  case 'o':
    file[1].play(3.0, 1.0);
    break;

  case 'p':
    file[2].play(3.0, 1.0);
    break;    

  case 'z':
    file[3].play(3.0, 1.0);
    break;

  case 'x':
    file[4].play(3.0, 1.0);
    break;

  case 'c':
    file[0].play(4.0, 1.0);
    break;    

  case 'v':
    file[1].play(4.0, 1.0);
    break;
  }
}