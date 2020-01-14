/*
 * Changing size and position of circles in a grid
 * - closely based on `P_2_1_2_01` from the book "Generative Design"
 *
 */

Gui gui;

import de.looksgood.ani.*;

// global variables for agents
float circleSize = 30;
float randomness = 50;
int seed = 0;
// number of tiles across width of grid 
int tiles;

// list of agents
ArrayList<Agent> agents;

void setup() {
  size(600, 600);
  //fullScreen();

  // denominator is size of tile
  tiles = width / 40;

  // you have to call always Ani.init() first!
  Ani.init(this);

  // setup the simple Gui
  gui = new Gui(this);

  // add parameters to the Gui
  gui.addSlider("tileSize", 2, 100);
  gui.addSlider("seed", 1, 100); 
  gui.addSpace();
  gui.addSlider("circleSize", 5, 50);
  gui.addSlider("randomness", 0, 100);

  createAgents(tiles);
}

// create the grid of agents, one agent per grid location
void createAgents(int tiles) {
  agents = new ArrayList<Agent>();

  // step size between grid centres
  float step = width / tiles;

  // create an Agent and place it at centre of each tile
  for (float x = step/2; x < width; x += step)
    for (float y = step/2; y < height; y += step) {
      Agent a = new Agent(x, y);
      agents.add(a);
    }
}

void draw() {
  background(255);

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
    seed++;
    launch();
  }
}

// tileSize is a callback function from the Gui
// (every time the tiles slide is adjusted)
void tileSize(float v) {
  tiles = width / int(v);
  createAgents(tiles);
}

void mouseReleased() {
  launch();
}

void launch() {
  // generate random numbers starting from this "seed"
  randomSeed(seed);
  // note how agent update is called here, not always in draw
  for (Agent a : agents) {
    a.update();
  }
}
