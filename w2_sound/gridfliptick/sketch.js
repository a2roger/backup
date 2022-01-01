

// parameters
let p = {
  // toggle filling screen or not
  fillScreen: false,

  // stroke weight
  weight: 5,
  weightMin: 0.5,
  weightMax: 32,

  // tile size
  tileSize: 50,
  tileSizeMin: 4,
  tileSizeMax: 100,

  // flip chance
  flipChance: 0.5,
  flipChanceMin: 0,
  flipChanceMax: 10,
  flipChanceStep: 0.01  
}

// my sound file
let tick;

// this is called before setup and it guarantees all assets will be 
// loaded and ready for use by the time setup is run
function preload() {
  tick = loadSound("data/254316__jagadamba__clock-tick.wav")
}

function setup() {
  createCanvas(600, 600)

  // add params to a GUI
  createParamGui(p, paramChanged);

  // load last params
  // s = getItem("params")

  // setup the window and create the agents
  createAgents()

  // turn down the sound
  tick.setVolume(0.1);
}

function draw() {

  background(250);

  // draw all the agents
  for (a of agents) {
    a.update();
    a.draw();
  }
}

let agents

// create the grid of agents, one agent per grid location
function createAgents() {

  // setup the canvas
  if (p.fillScreen) {
    resizeCanvas(windowWidth, windowHeight)
  } else {
    resizeCanvas(600, 600)
  }

  // denominator is size of tile
  let tiles = width / p.tileSize;

  agents = [];

  // step size between grid centres
  let step = width / tiles;
  // the length of an agent's line (diagonal line of tile)
  let length = sqrt(step * step + step * step);

  // create an Agent object and place it at centre of each tile
  for (x = step / 2; x < width; x += step)
    for (y = step / 2; y < height; y += step) {
      let a = new Agent(x, y, length);
      agents.push(a);
    }
}

function keyPressed() {
}

function mousePressed() {
}

function windowResized() {
  createAgents()
}

// global callback from the settings GUI
function paramChanged(name) {
  if (name == "tileSize" || name == "fillScreen") {
    createAgents()
  }
}