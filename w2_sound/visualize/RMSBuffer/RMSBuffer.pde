import processing.sound.*;

// Demonstrates the use of RMS (root mean square) to visual audio input.

Gui gui;

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
int PrevSteps = 100;
int StepAmount = 0;
float Y_Multiplier = 5;
float Y_Global = 0;
float X_Multiplier = 10;
float X_Global = 0;
int num_lines = 30;

// Buffer
PVector[] point_buffer; 

void setup() {
    //fullScreen();
    size(1200,600);

    //Load and play a soundfile and loop it
    sample = new SoundFile(this, "UltraCat_03_Space_Love_Attack.mp3");
    sample.loop();
    
    // Create and patch the rms tracker
    rms = new Amplitude(this);
    rms.input(sample);
    
    // Initial values 
    position = width;
    StepAmount = width/Steps;
    
    // Init buffer
    point_buffer = new PVector[Steps];
    for (int i = 0; i < Steps; ++i) {
       point_buffer[i] = new PVector(-1, -1); 
    }
    
    // Init background
    background(125,125,125);
    
    // setup the simple Gui
    gui = new Gui(this);
  
    gui.addSlider("Steps", 10, 200);
    gui.addSlider("Y_Multiplier", -20.0, 20.0);
    gui.addSlider("Y_Global", -200.0, 200.0);
    gui.addSlider("X_Multiplier", -20.0, 20.0);
    gui.addSlider("X_Global", -200.0, 200.0);
    gui.addSlider("Scale", 0.2, 8);
    gui.addSlider("smooth_factor", 0.0, 1.0);
    gui.addSlider("num_lines", 1, 100);
}      

int bufferIndex = 0;
void draw() {
    background(125,125,125);
    
    // Hack to adjust steps
    if (Steps != PrevSteps) {
        // Init buffer
        point_buffer = new PVector[Steps];
        for (int i = 0; i < Steps; ++i) {
           point_buffer[i] = new PVector(-1, -1); 
        }
        PrevSteps = Steps;
        bufferIndex = 0;
    }
    
    // smooth the rms data by smoothing factor (0-1)
    float raw = rms.analyze();
    
    // Low pass filter
    float rms = rmsPrev * (1 - smooth_factor) + raw * smooth_factor;  

    // rms.analyze() return a value between 0 and 1. It's
    float rms_scaled=(rms*Scale*height);
    rmsPrev = rms;
    
    // Draw visualization
    point_buffer[bufferIndex] = new PVector((float)position, rms_scaled);
    
    for (int j = 0; j < Steps; ++j) {
      PVector current = point_buffer[j]; 
      PVector previous = point_buffer[(j - 1 < 0) ? Steps - 1 : j - 1];
      
      if (current.x < 0 || abs(current.x - previous.x) > 200) continue;
      
      for (int i = 0; i < num_lines; i++){
        float y_offset = (i - num_lines/2) * Y_Multiplier + Y_Global;
        float x_offset = (i - num_lines/2) * X_Multiplier + X_Global;
        
        float colorval = map(x_offset * y_offset, 0, 200, 0, 3);
        noStroke();
        fill(255, colorval, 150);
        ellipse(current.x + x_offset, current.y + y_offset, rms*50, rms*50);
        
        stroke(255, colorval, 150);
        line(current.x + x_offset, current.y + y_offset, previous.x + x_offset, previous.y + y_offset);
      }
    }
    
    // Increment Index
    bufferIndex++;
    if (bufferIndex >= Steps) bufferIndex = 0;
    
    // Adjust position
    position -= StepAmount;
    if (position <= -100) {
      position = width; 
    }
}


void Steps(int steps) {
    // Adjust step
    StepAmount = width/steps;
    Steps = steps;
}
