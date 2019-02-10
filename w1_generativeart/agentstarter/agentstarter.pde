/*
 * Starter code for creating a generative drawing using agents
 * 
 *
 */

Gui gui;

// list of agents
ArrayList<Agent> agents;

int agentsCount;

// add your agent parameters here
float param = 1;

void setup() {
  size(800, 600);
  //fullScreen();

  agentsCount = height / 3;

  // setup the simple Gui
  gui = new Gui(this);

  gui.addSlider("agentsCount", 10, height);
  gui.addSlider("param", 0, 5);
  createAgents();
}

void createAgents() {

  background(255);
  // create Agents in a centred starting grid
  agents = new ArrayList<Agent>();
  for (int i = 0; i < agentsCount; i++) {
    Agent a = new Agent();
    agents.add(a);
  }
}

void draw() {

  // update all agents
  // draw all the agents
  for (Agent a : agents) {
    a.update();
  }

  // draw all the agents
  for (Agent a : agents) {
    a.draw();
  }

  // draw Gui last
  gui.draw();

  // interactively adjust agent parameters
  //param = map(mouseX, 0, width, 0, 10);
}

// enables shortcut keys for the Gui
// 'm' or 'M' to show menu, 'm' to partially hide, 'M' to fully hide
void keyPressed() {
  gui.keyPressed();

  // space to reset all agents
  if (key == ' ') {
    createAgents();
  }
}

// call back from Gui
void agentsCount(int n) {
  agentsCount = n;
  createAgents();
}