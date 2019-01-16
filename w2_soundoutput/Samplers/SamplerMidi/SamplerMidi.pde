import processing.sound.*;
import javax.sound.midi.*;
import java.io.*;

Gui gui;

// Synth Var
TriOsc triOsc;
Env env; 
MidiLoader midiload;

Note[] notes;
float position = 0; 
float step = 0;

// Times and levels for the ASR envelope
float attackTime = 0.02;
float sustainTime = 0.12;
float sustainLevel = 0.3;
float releaseTime = 0.2;

void setup() {
  size(640, 360);
  colorMode(HSB, 360, 100, 100);
  

  // Init midi
  midiload = new MidiLoader(dataPath("")+"/mozart_fugue_401_(c)garty.mid");

  // Init osc
  triOsc = new TriOsc(this);

  // Create the envelope 
  env  = new Env(this); 

  // Create note array
  notes = new Note[100];
  for (int i = 0; i < 100; ++i) 
  {
    float x = i * width/100;
    notes[i] = new Note(x);
  }
  position = width;
  step = width/100;

  // setup the simple Gui
  gui = new Gui(this);

  gui.addSlider("attackTime", 0.001, 0.5);
  gui.addSlider("sustainTime", 0.001, 0.5);
  gui.addSlider("sustainLevel", 0.001, 0.5);
  gui.addSlider("releaseTime", 0.001, 0.5);
}

void draw() {
  background(0);
  
  // Call back to midi
  midiload.draw();
  for(Note n : notes)
  {
    n.draw();
  }
  for (int i = 0; i < notes.length - 1; ++i)
  {
    notes[i].DeepCopy(notes[i+1]);
  }
}

// This function calculates the respective frequency of a MIDI note
float midiToFreq(int note) {
  return (pow(2, ((note-69)/12.0)))*440;
}

int prevNote = -1;
// **IMPORTANT TO IMPLEMENT THIS**
void NoteCallback(int note, int velocity) {
  if (velocity == 0 || prevNote == note) {
    //triOsc.stop();
    return; //<>//
  }
  
  notes[notes.length - 1].set(note, velocity);
  
  // Play the oscillator at the key frequency
  triOsc.play(midiToFreq(note), velocity/128.0 * 0.5 + 0.2 );

  // Applys a envolope on the osc (ASR)
  env.play(triOsc, attackTime, sustainTime, sustainLevel, releaseTime);
  prevNote = note;
}
