/*
 * Grid of shape agents that turn or scale relative to the mouse
 * - closely based on `P_2_1_1_04` from the book "Generative Design"
 *
 */

Gui gui;

import de.looksgood.ani.*;

// global variables for agents
float shapeScale = 1;
float shapeAngle = 0; 
int shapeNum = 1;
float maxDist;
float distScale = 1;
// number of tiles across width of grid 
int tiles; 

// list of agents
ArrayList<Agent> agents;

void setup() {
  size(600, 600);
  //fullScreen();

  // denominator is size of tile
  tiles = width / 50;

  // you have to call always Ani.init() first!
  Ani.init(this);

  // setup the simple Gui
  gui = new Gui(this);

  // add parameters to the Gui
  gui.addSlider("tileSize", 2, 100);
  gui.addSlider("shape", 1, 8); 
  gui.addSpace();
  gui.addSlider("shapeScale", 0.5, 3);
  gui.addSlider("shapeAngle", -180, 180);
  gui.addSlider("distScale", 0.25, 3);
  
  maxDist = sqrt(sq(width) + sq(height));

  createAgents(tiles);
}

// create the grid of agents, one agent per grid location
void createAgents(int tiles) {

  // load the SVG shape 
  PShape shape = loadShape("module_" + shapeNum + ".svg");
  
  agents = new ArrayList<Agent>();

  // step size between grid centres
  float step = width / tiles;
  // the length of the agents line (diagonal line of tile)
  float length = sqrt(step * step + step * step);

  // create an Agent and place it at centre of each tile
  for (float x = step/2; x < width; x += step)
    for (float y = step/2; y < height; y += step) {
      Agent a = new Agent(x, y, shape);
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
}

// tileSize is a callback function from the Gui
// (every time the tiles slide is adjusted)
void tileSize(float v) {
  tiles = width / int(v);
  createAgents(tiles);
}

// Gui callback when the shape slider changes
void shape(int s) {
  shapeNum = s;
  createAgents(tiles);
}