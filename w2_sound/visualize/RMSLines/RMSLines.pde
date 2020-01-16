import processing.sound.*;

// Demonstrates the use of RMS (root mean square) to visual audio input.

// Declare the processing sound variables 
SoundFile sample;
Amplitude rms;

// Declare a scaling factor
float Scale=5;

// Declare a smooth factor
float smooth_factor=0.1;

// Vars
float rmsPrev = 0;
int position = 0;
int Steps = 100;
int StepAmount = 0;
PVector previous;

Gui gui;
int Y_Multiplier = 5;
int X_Multiplier = 10;

int num_lines = 30;

void setup() {
    //fullScreen();
    size(1200,300);

    //Load and play a soundfile and loop it
    sample = new SoundFile(this, "beat.aiff");
    sample.loop();
    
    // Create and patch the rms tracker
    rms = new Amplitude(this);
    rms.input(sample);
    
    // Initial values 
    position = width;
    StepAmount = width/Steps;
    
    // Set previous point
    previous = new PVector(width, height);
    
    // Setup buffer
    
    
    // Init background
    background(125,125,125);
    
    // setup the simple Gui
    gui = new Gui(this);
  
    gui.addSlider("Steps", 10, 200);
    gui.addSlider("Y_Multiplier", 0, 100);
    gui.addSlider("X_Multiplier", 0, 100);
    gui.addSlider("Scale", 0.2, 8);
    gui.addSlider("smooth_factor", 0.0, 1.0);
    gui.addSlider("num_lines", 1, 100);
}      


void draw() {
    // smooth the rms data by smoothing factor (0-1)
    float raw = rms.analyze();
    
    // Low pass filter
    float rms = rmsPrev * (1 - smooth_factor) + raw * smooth_factor;  

    // rms.analyze() return a value between 0 and 1. It's
    float rms_scaled=(rms*Scale*height);
    rmsPrev = rms;
    
    // Draw visualization
    PVector current = new PVector((float)position, rms_scaled);
    for (int i = 0; i < num_lines; i++){
      int x_offset = (i - num_lines/2) * Y_Multiplier;
      int y_offset = (i - num_lines/2) * X_Multiplier;
      
      float colorval = map(x_offset * y_offset, 0, 200, 0, 3);
      noStroke();
      fill(255, colorval, 150);
      //ellipse(current.x + x_offset, current.y + y_offset, rms*50, rms*50);
      
      stroke(255, colorval, 150);
      line(current.x + x_offset, current.y + y_offset, previous.x + x_offset, previous.y + y_offset);
    }
    
    // Set previous to current
    previous = current;
    
    // Change position
    position -= StepAmount;
    if (position <= -100) {
      background(125,125,125);
      previous = new PVector(width, height);
      position = width; 
    }
    
    
}

void Steps(int count) {
    // Adjust step
    StepAmount = width/count;
}

void keyPressed() {
  if (key == CODED) {
    if (keyCode == UP) {
      background(125,125,125);
    } 
  }
}
