/* //<>//
 * Agents move around the canvas leaving a trail.
 * 
 *
 */

import ddf.minim.*;
import ddf.minim.ugens.*;
import ddf.minim.effects.*;

Gui gui;

// Numbers of samples
int num_samples = 11;

// list of agents
ArrayList<Agent> agents;

int agentsCount;

// controls if agents interact with each other
// which creates other interesting effects
boolean interact = true;

// Minim Sound processor
Minim minim;

void setup() {
  //size(800, 600);
  fullScreen();

  agentsCount = num_samples;

  // setup the simple Gui
  gui = new Gui(this);

  gui.addSlider("agentsCount", 10, height);

  colorMode(HSB, 360, 100, 100, 100);
  background(0);

  // Init Minim
  minim = new Minim(this);

  createAgents();
}

void createAgents() {

  agents = new ArrayList<Agent>();
  for (int i = 0; i < agentsCount; i++) {
    //// Make file path
    int num = floor(random(1, num_samples + 1));
    String filepath = dataPath("") + "/" + num + ".aiff";
    println(filepath);

    Agent a = new Agent(this, minim, filepath);
    agents.add(a);
  }
}

void draw() {

  background(0);

  // update all agents
  // draw all the agents
  for (Agent a : agents) {
    a.update();
  }

  if (interact) {
    // if two agents touch, start playing file. 
    for (int i = 0; i < agents.size(); i++) {
      for (int j = i + 1; j < agents.size(); j++) {

        Agent a = agents.get(i);
        Agent b = agents.get(j);

        float threshold = 50;
        float d = dist(a.x, a.y, b.x, b.y);
        if (d < threshold) {
          a.play();
        }
        if (d < threshold*5){
          a.drawLine(b, map(d, threshold*5, 0, 0.1, 3.0));
        }
      }
    }
  }


  // draw all the agents
  for (Agent a : agents) {
    a.draw();
  }

  // draw Gui last
  gui.draw();
}

// enables shortcut keys for the Gui
// 'm' or 'M' to show menu, 'm' to partially hide, 'M' to fully hide
void keyPressed() {
  gui.keyPressed();

  if (key == ' ') {
    background(0);
    createAgents();
  }
}

void agentsCount(int n) {
  agentsCount = n;
  createAgents();
}