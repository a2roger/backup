// This sketch shows how to use the FFT class to analyze a stream  
// of sound. Change the variable bands to get more or less 
// spectral bands to work with. Smooth_factor determines how
// much the signal will be smoothed on a scale form 0-1.

import processing.sound.*;

// Declare the processing sound variables 
SoundFile sample;
FFT fft;
AudioDevice device;
Gui gui;

// Declare a scaling factor
float Scale=2.5;

// Define how many FFT bands we want
int bands = 128;

// declare a drawing variable for calculating rect width
float r_width;

// Create a smoothing vector
float[] sum = new float[bands];

// Create a smoothing factor
float smooth_factor = 1.0;

// Vars
int position = 0;
int Steps = 300;
int StepAmount = 0;
float start_hue = 260;

// Change to polar
boolean is_polar = false;

public void setup() {
  size(640, 360);
  background(0);
  colorMode(HSB,360,100,100);
  
  // If the Buffersize is larger than the FFT Size, the FFT will fail
  // so we set Buffersize equal to bands
  device = new AudioDevice(this, 44000, bands);
  
  // Calculate the width of the rects depending on how many bands we have
  r_width = width/float(bands);
  
  //Load and play a soundfile and loop it. This has to be called 
  // before the FFT is created.
  sample = new SoundFile(this, "Mecha_Action.aiff");
  //sample.pan(0);
  sample.loop();

  // Create and patch the FFT analyzer
  fft = new FFT(this, bands);
  fft.input(sample);
    
  // Initial values 
  position = width;
  StepAmount = width/Steps;
    
  // setup the simple Gui
  gui = new Gui(this);

  gui.addSlider("Steps", 10, 500);
  gui.addSlider("Scale", 0.2, 10);
  gui.addSlider("smooth_factor", 0.0, 1.0);
}      

public void draw() {
  // Set background color, noStroke and fill color
  //background(125);


  fft.analyze();

  for (int i = 0; i < bands; i++) {
    
    // smooth the FFT data by smoothing factor (Lowpass filter)
    sum[i] = sum[i] * (1 - smooth_factor) + fft.spectrum[i] * smooth_factor;
    
    // draw the rects with a scale factor
    float size = sum[i] *Scale * 100;
    size = (size > 5) ? 5 : size;
    
    fill(start_hue + map(i, 0, bands, 0, 60), 100, 100);
    noStroke();
    
    // Coordinates
    float x =0, y = 0;
    if (!is_polar) {
      x = position;
      y = height - (i * height/bands);
    }
    else 
    {
      float r = i * height/bands;
      float theta = radians(map(position, 0, width, 0, 360));
      
      // Convert into cartesian coordinates
      x = r * cos(theta) + width/2.0;
      y = r * sin(theta) + height/2.0;
    }
    
    ellipse(x, y, size, size);
    //rect( i*r_width, height, r_width, -sum[i]*height*Scale );
  }
  
  // Change position
  position -= StepAmount;
  if (position <= 0) {
    if(!is_polar)
      background(0);
    else 
      start_hue = (start_hue + 0.5) % 360;
    position = width; 
  }
}

void Steps(int count) {
    // Adjust step
    StepAmount = width/count;
}