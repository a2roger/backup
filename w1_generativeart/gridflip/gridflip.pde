/*
 * Grid of agents that flip their horizontal line 
 * - closely based on `P_2_1_1_01` from the book "Generative Design"
 *
 */

Gui gui; 

import de.looksgood.ani.*;

// global variables for agents
float weight = 1;
// number of tiles across width of grid 
int tiles; 

// list of agents
ArrayList<Agent> agents;

void setup() {
  size(600, 600);
  //fullScreen();

  // denominator is size of tile
  tiles = width / 30;

  // you have to call always Ani.init() first!
  Ani.init(this);

  // setup the simple Gui
  gui = new Gui(this);
  
  // add parameters to the Gui
  gui.addSlider("tileSize", 2, 100);
  gui.addSlider("weight", 1, 20);

  createAgents(tiles);
}

// create the grid of agents, one agent per grid location
void createAgents(int tiles) {
  
  agents = new ArrayList<Agent>();

  // step size between grid centres
  float step = width / tiles;
  // the length of an agent's line (diagonal line of tile)
  float length = sqrt(step * step + step * step);

  // create an Agent object and place it at centre of each tile
  for (float x = step/2; x < width; x += step)
    for (float y = step/2; y < height; y += step) {
      Agent a = new Agent(x, y, length);
      agents.add(a);
    }
}

void draw() {
  background(255);

  // draw all the agents
  for (Agent a : agents) {
    a.update();
    a.draw();
  }

  // draw Gui last
  gui.draw();
}

// enables shortcut keys for the Gui
// 'm' or 'M' to show menu, 'm' to partially hide, 'M' to fully hide
void keyPressed() {
  gui.keyPressed();
  
  // SPACE to create new image
  if (key == ' ') createAgents(tiles);
}

// tileSize is a callback function from the Gui
// (every time the tiles slide is adjusted)
void tileSize(float v) {
  tiles = width / int(v);
  createAgents(tiles);
}
