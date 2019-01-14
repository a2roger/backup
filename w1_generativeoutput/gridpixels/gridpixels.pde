/*
 * Changing size and position of circles in a grid
 * - closely based on `P_2_1_2_01` from the book "Generative Design"
 *
 */

Gui gui;

// global variables for agents
float xfactor = 1;
float yfactor = 1;
int drawMode = 1;
int tiles = 10; // grid size is tiles by tiles
PImage img;

// list of agents
ArrayList<Agent> agents;

void setup() {
  //size should be multiple of img width and height
  size(670, 970); 

  // setup the simple Gui
  gui = new Gui(this);

  // add parameters to the Gui
  gui.addSlider("drawMode", 1, 9); 
  gui.addSpace();
  gui.addSlider("xfactor", 0, 10);
  gui.addSlider("yfactor", 0, 10);

  img = loadImage("yoko1.png");

  createAgents(tiles);
}

// create the grid of agents, one agent per grid location
void createAgents(int tiles) {

  agents = new ArrayList<Agent>();

  // step size between grid centres
  float step = width / img.width;
  // the length of the agents line (diagonal line of tile)
  float length = sqrt(step * step + step * step);

  // create an Agent and place it at centre of each tile
  for (int px = 0; px < img.width; px++) {
    for (int py = 0; py < img.height; py++) {
      Agent a = new Agent(px * step, py * step, px, py);
      agents.add(a);
    }
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