/*
 * Agents move around the canvas leaving a trail.
 * 
 *
 */

Gui gui;

// list of agents
ArrayList<Agent> agents;

int agentsCount;

// maximum step size to take
float maxStep = 0.1;
// the probability % to turn
float probTurn = 0.01;
// base colour
float baseHue = 0;

// controls if agents interact with each other
// which creates other interesting effects
boolean interact = false;


void setup() {
  size(800, 600);
  //fullScreen();

  agentsCount = height / 3;

  // setup the simple Gui
  gui = new Gui(this);

  gui.addSlider("agentsCount", 10, height);
  gui.addSlider("baseHue", 0, 360);
  gui.addSpace();
  gui.addSlider("maxStep", 0, 1);
  gui.addSlider("probTurn", 0, 1);

  colorMode(HSB, 360, 100, 100, 100);
  background(0);

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

  // update all agents
  // draw all the agents
  for (Agent a : agents) {
    a.update();
  }

  if (interact) {
    // if two agents touch, then kill one and give the weight to the other
    for (int i = 0; i < agents.size(); i++) {
      for (int j = i + 1; j < agents.size(); j++) {

        Agent a = agents.get(i);
        Agent b = agents.get(j);

        float threshold = a.weight / 2 + b.weight / 2;
        float d = dist(a.x, a.y, b.x, b.y);
        if (d < threshold) {
          if (a.weight > b.weight) {
            a.weight += b.weight;
            b.reset();
          } else {
            b.weight += b.weight;
            a.reset();
          }
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

  // interactively adjust agent parameters
  maxStep = map(mouseX, 0, width, 0.1, 3);
  probTurn = map(mouseY, 0, height, 0.01, 0.1);
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