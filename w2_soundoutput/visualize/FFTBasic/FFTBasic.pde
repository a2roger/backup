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
int Scale=5;

// Define how many FFT bands we want
int bands = 128;
int Bands = 128;

// declare a drawing variable for calculating rect width
float r_width;

// Create a smoothing vector
float[] sum;

// Create a smoothing factor
float smooth_factor = 0.2;

public void Setup_FFT() {
  // Create temp sum
  sum = new float[bands];
  
  // Calculate the width of the rects depending on how many bands we have
  r_width = width/float(bands);
  
  // Create and patch the FFT analyzer
  fft = new FFT(this, bands);
  fft.input(sample);
  
}

public void setup() {
  size(640, 360);
  background(125);
  
  // If the Buffersize is larger than the FFT Size, the FFT will fail
  // so we set Buffersize equal to bands
  device = new AudioDevice(this, 44000, bands);
  
  //Load and play a soundfile and loop it. This has to be called 
  // before the FFT is created.
  sample = new SoundFile(this, "Mecha_Action.aiff");
  sample.loop();
  
  // Setup FFT
  Setup_FFT();
  
  // setup the simple Gui
  gui = new Gui(this);

  gui.addSlider("Bands", 2, 1024);
  gui.addSlider("Scale", 0.2, 100);
  gui.addSlider("smooth_factor", 0.0, 1.0);
}      

public void draw() {
  // Check bands for power of 2
  if ((Bands & (Bands - 1)) != 0){
      // Log base 2
      float factor = (float)(Math.log(Bands)/Math.log(2.0)); //<>//
      Bands = (int) pow(2, (round(factor))); //<>//
      gui.setSliderValue("Bands", Bands);
  }
  
  
  // Set background color, noStroke and fill color
  background(125);
  fill(255,0,150);
  noStroke();

  fft.analyze();

  for (int i = 0; i < bands; i++) {
    
    // smooth the FFT data by smoothing factor (Exponential filter)
    sum[i] = sum[i] * (1 - smooth_factor) + fft.spectrum[i] * smooth_factor;
    
    // draw the rects with a scale factor
    rect( i*r_width, height, r_width, -sum[i]*height*Scale );
  }
}

void keyPressed(){
  
  // Rest bands
  if (key == ' '){
    bands = Bands;
    Setup_FFT();
  }
}
