// This sketch shows how to use the FFT class to analyze a stream   //<>//
// of sound. Change the variable bands to get more or less 
// spectral bands to work with. Smooth_factor determines how
// much the signal will be smoothed on a scale form 0-1.

import processing.sound.*;

// Declare the processing sound variables 
SoundFile sample;
FFT fft;
Gui gui;

// Declare a scaling factor
float Scale=2.5;

// Define how many FFT bands we want
int bands = 128;
int Bands = 128;

// declare a drawing variable for calculating rect width
float r_width;

// Create a smoothing vector
float[] sum = new float[bands];
EllipseContainer[][] eMat;

// Create a smoothing factor
float smooth_factor = 1.0;

// Vars
int position = 0;
int Steps = 300;
float StepAmount = 0;
float start_hue = 260;

// Change to polar
boolean is_polar = false;

public void Setup_FFT() {
  // Create temp sum
  StepAmount = width/Steps;
  sum = new float[bands];
  eMat = new EllipseContainer[bands][Steps];
  for (int j = 0; j < Steps; ++j) { //<>//
    for (int i = 0; i < bands; ++i) { //<>//

      // Coordinates
      float x =0, y = 0;
      if (!is_polar) {
        x = j * StepAmount;
        y = height - (i * height/bands);
      } else 
      {
        float r = i * height/bands;
        float theta = radians(map(j, 0, Steps, 0, 360));

        // Convert into cartesian coordinates
        x = r * cos(theta) + width/2.0;
        y = r * sin(theta) + height/2.0;
      }
      
      eMat[i][j] = new EllipseContainer(j, i, start_hue, StepAmount, bands);
      eMat[i][j].SetCoord(x, y);
    }
  }

  // Calculate the width of the rects depending on how many bands we have
  r_width = width/float(bands);

  // Create and patch the FFT analyzer
  fft = new FFT(this, bands);
  fft.input(sample);
}

public void setup() {
  size(1000, 1000);
  background(0);
  colorMode(HSB, 360, 100, 100);

  //Load and play a soundfile and loop it. This has to be called 
  // before the FFT is created.
  sample = new SoundFile(this, "Mecha_Action.aiff");
  sample.loop();

  // Initial values 
  position = width;
  Steps = width;
 
  // Setup FFT
  Setup_FFT();

  // setup the simple Gui
  gui = new Gui(this);

  gui.addSlider("Bands", 2, 2048);
  gui.addSlider("Steps", 10, 500);
  gui.addSlider("Scale", 0.2, 10);
  gui.addSlider("smooth_factor", 0.0, 1.0);
}      

public void draw() {
  background(0);

  // Check bands for power of 2
  if ((Bands & (Bands - 1)) != 0) {
    // Log base 2
    float factor = (float)(Math.log(Bands)/Math.log(2.0));
    Bands = (int) pow(2, (round(factor)));
    gui.setSliderValue("Bands", Bands);
  }

  // Copy down viz (next step to previous step)
  for (int j = 0; j < Steps - 1; ++j) {
    for (int i = 0; i < bands; ++i) {
      eMat[i][j].DeepCopy(eMat[i][j+1]);
    }
  }

  fft.analyze();

  for (int i = 0; i < bands; i++) {

    // smooth the FFT data by smoothing factor (Lowpass filter)
    sum[i] = sum[i] * (1 - smooth_factor) + fft.spectrum[i] * smooth_factor;

    // draw the rects with a scale factor
    float size = sum[i] *Scale * 100;
    size = (size > 5) ? 5 : size;

    float hue = start_hue + map(i, 0, bands, 0, 60);
    
    // Store
    eMat[i][Steps - 1].SetColorSize(size, hue);
  }

  // Draw entire screen
  for (int j = 0; j < Steps; ++j) {
    for (int i = 0; i < bands; ++i) {
      eMat[i][j].Draw();
    }
  }

  //// Change position
  position -= StepAmount;
  if (position <= 0) {
    if (!is_polar)
    {
      //background(0);
    } else 
    start_hue = (start_hue + 0.5) % 360;
    position = width;
  }
}

void Steps(int count) {
  // Adjust step
  StepAmount = width/count;
  Steps = count;
  Setup_FFT();
}

void keyPressed() {

  // Rest bands
  if (key == ' ') {
    bands = Bands;
    Setup_FFT();
  }
  if (key=='p')
  {
    is_polar = !is_polar;
  }
}
