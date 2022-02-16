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
  createCanvas(400, 400)
  
  // add params to a GUI
  createParamGui(p, paramChanged);
  _paramGui.setPosition(10, 10); // can customize where GUI is drawn
  // _paramGui.hide(); // uncomment to hide for presentations

  // set colour for your frame
  select('body').style('background: #000000;')

  // don't centre
  // select('body').style('place-items: start start;')
  // _paramGui.setPosition(width + 10, 10); // can customize where GUI is drawn  

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



