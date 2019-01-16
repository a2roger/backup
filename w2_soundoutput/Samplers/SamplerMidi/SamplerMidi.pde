import processing.sound.*;
import javax.sound.midi.*;
import java.io.*;

Gui gui;

// Synth Var
TriOsc triOsc;
Env env; 
MidiLoader midiload;

// Times and levels for the ASR envelope
float attackTime = 0.001;
float sustainTime = 0.004;
float sustainLevel = 0.3;
float releaseTime = 0.2;

void setup() {
  size(640, 360);
  colorMode(HSB, 360, 100, 100);
  background(255);

  // Init midi
  midiload = new MidiLoader(dataPath("")+"/nocturne_op_9_1_2979_r_(nc)smythe.mid");
  
  // Init osc
  triOsc = new TriOsc(this);
  
  // Create the envelope 
  env  = new Env(this); 
  
  // setup the simple Gui
  gui = new Gui(this);

  gui.addSlider("attackTime", 0.001, 0.5);
  gui.addSlider("sustainTime", 0.001, 0.5);
  gui.addSlider("sustainLevel", 0.001, 0.5);
  gui.addSlider("releaseTime", 0.001, 0.5);
}

void draw() {
  // Call back to midi
  midiload.draw();

}

// This function calculates the respective frequency of a MIDI note
float midiToFreq(int note) {
  return (pow(2, ((note-69)/12.0)))*440;
}

// **IMPORTANT TO IMPLEMENT THIS**
void NoteCallback(int note, int velocity) {
      // Play the oscillator at the key frequency
    triOsc.play(midiToFreq(note),velocity/128.0);
    
    // Applys a envolope on the osc (ASR)
    env.play(triOsc, attackTime, sustainTime, sustainLevel, releaseTime);      
}