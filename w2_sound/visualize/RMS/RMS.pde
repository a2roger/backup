// This sketch shows how to use the Amplitude class to analyze a
// stream of sound. In this case a sample is analyzed. Smooth_factor
// determines how much the signal will be smoothed on a scale
// form 0-1.

import processing.sound.*;

// Declare the processing sound variables 
SoundFile sample;
Amplitude rms;

// Declare a scaling factor
float Scale = 5;

// Declare a smooth factor
float smooth_factor = 0.25;

// Used for smoothing
float sum, rmsPrev;

Gui gui;

public void setup() {
    size(640, 360);

    //Load and play a soundfile and loop it
    sample = new SoundFile(this, "beat.aiff");
    sample.loop();
    
    // Create and patch the rms tracker
    rms = new Amplitude(this);
    rms.input(sample);
    
    // setup the simple Gui
    gui = new Gui(this);
    gui.addSlider("Scale", 0.2, 8);
    gui.addSlider("smooth_factor", 0.0, 1.0);
}      

public void draw() {
    // Set background color, noStroke and fill color
    background(125,125,125);
    noStroke();
    fill(255,0,150);
    
    // smooth the rms data by smoothing factor (0-1)
    float raw = rms.analyze();
    
    // Low pass filter
    float rms = rmsPrev * (1 - smooth_factor) + raw * smooth_factor;  

    // rms.analyze() return a value between 0 and 1. It's
    float rms_scaled = (rms*Scale*height);
    rmsPrev = rms;

    // We draw an ellispe coupled to the audio analysis
    ellipse(width/2, height/2, rms_scaled, rms_scaled);
}
