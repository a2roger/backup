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

let socket;

function setup() {
  createCanvas(400, 400)
  
  // add params to a GUI
  createParamGui(p, paramChanged);
  _paramGui.setPosition(10, 10); // can customize where GUI is drawn
  // _paramGui.hide(); // uncomment to hide for presentations

  // set colour for your frame
  select('body').style('background: #000000;')

  socket = io.connect('http://localhost:3000')

  socket.on('mouse', function(data) {
    print(data)
    noStroke();
    fill('#00ff00')
    circle(data.x, data.y, 16);
  })

  // don't centre
  // select('body').style('place-items: start start;')
  // _paramGui.setPosition(width + 10, 10); // can customize where GUI is drawn  

 }

function draw() {
  // background(240)
 
}

function keyPressed() {
  if (key == ' ') {
  }
}

function mousePressed() {
}

function mouseDragged() {
  noStroke()
  fill('#ff0000')
  circle(mouseX, mouseY, 16);

  let data = { x: mouseX, y: mouseY }
  socket.emit('mouse', data)
}

function windowResized() {
}

// global callback from the settings GUI
function paramChanged(name) {
}



