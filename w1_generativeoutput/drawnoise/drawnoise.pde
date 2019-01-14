// M_1_5_02_TOOL.pde
// Agent.pde, GUI.pde
// 
// Generative Gestaltung, ISBN: 978-3-87439-759-9
// First Edition, Hermann Schmidt, Mainz, 2009
// Hartmut Bohnacker, Benedikt Gross, Julia Laub, Claudius Lazzeroni
// Copyright 2009 Hartmut Bohnacker, Benedikt Gross, Julia Laub, Claudius Lazzeroni
//
// http://www.generative-gestaltung.de
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

/**
 * noise values (noise 2d) are used to animate a bunch of agents.
 * 
 * KEYS
 * m                   : toogle menu open/close
 * 1-2                 : switch noise mode
 * space               : new noise seed
 * backspace           : clear screen
 * s                   : save png
 */

Gui gui;


// list of agents
ArrayList<Agent> agents;

int agentsCount = 4000;

float noiseScale = 300;
float noiseStrength = 10; 
float overlayAlpha = 10;
float agentsAlpha = 90;
float strokeWidth = 0.3;
int drawMode = 1;


void setup() {
  size(1280, 800);
  //fullScreen();

  // setup the simple Gui
  gui = new Gui(this);

  gui.addSlider("agentsCount", 1, 10000);
  gui.addSpace();
  gui.addSlider("noiseScale", 1, 1000); 
  gui.addSlider("noiseStrength", 1, 100); 
  gui.addSpace();
  gui.addSlider("strokeWidth", 1, 10); 
  gui.addSpace();
  gui.addSlider("agentsAlpha", 0, 255); 
  gui.addSlider("overlayAlpha", 0, 255); 
  
  createAgents();
}

void createAgents() {

  agents = new ArrayList<Agent>();
  for (int i = 0; i < agentsCount; i++) {
    Agent a = new Agent();
    agents.add(a);
  }
}

void draw() {
  fill(255, overlayAlpha);
  noStroke();
  rect(0, 0, width, height);

  stroke(0, agentsAlpha);

  // draw all the agents
  for (Agent a : agents) {
    if (drawMode == 1) {
      a.update1();
    } else {
      a.update2();
    }
    a.draw();
  }

  // draw Gui last
  gui.draw();
}

// enables shortcut keys for the Gui
// 'm' or 'M' to show menu, 'm' to partially hide, 'M' to fully hide
void keyPressed() {
  gui.keyPressed();

  if (key == '1') drawMode = 1;
  if (key == '2') drawMode = 2;
  if (key == ' ') {
    int newNoiseSeed = (int) random(100000);
    println("newNoiseSeed: "+newNoiseSeed);
    noiseSeed(newNoiseSeed);
  }
  if (key == DELETE || key == BACKSPACE) background(255);
}

void agentsCount(int n) {
  agentsCount = n;
  createAgents();
}