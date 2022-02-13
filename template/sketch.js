// parameters
let p = {
  boolean: true,
  numeric: 50,
  numericMin: 0,
  numericMax: 100,
  numericStep: 1,
}

function preload() {
}

function setup() {
  createCanvas(500, 500)
  
  // add params to a GUI
  createParamGui(p, paramChanged);
 }

function draw() {
  background(240)
 
}

function keyPressed() {
  if (key == ' ') {
  }
}

function mousePressed() {
}

function windowResized() {
}

// global callback from the settings GUI
function paramChanged(name) {
}



