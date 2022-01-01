

// parameters
let p = {

  // fft smoothing
  smoothing: 0.8,
  smoothingMin: 0.01,
  smoothingMax: 0.99,
  smoothingStep: 0.01,

  // 2^bins bins (16 to 1024)
  bins: 8,
  binsMin: 4,
  binsMax: 10,
}

// my sound file
let sound;

// amplitude analyzer
let amplitude;

function preload() {
  sound = loadSound("data/mecha-action.mp3")
}

function setup() {
  createCanvas(600, 300)

  // add params to a GUI
  createParamGui(p, paramChanged);

  sound.play()

  initalizeAnalysis();
}

function initalizeAnalysis() {
  print(`amplitude with ${p.smoothing}`)
  amplitude = new p5.Amplitude(p.smoothing);
  amplitude.setInput(sound);
}

function draw() {
  background(250);

  let level = amplitude.getLevel();

  let d = map(level, 0, 1, 0, height);
  noStroke();
  fill(255, 0, 0, 100);  
  circle(width/2, height/2, d);  
}


function keyPressed() {
  if (key = " ") {
    if (sound.isPlaying()) {
      sound.pause();
    } else {
      sound.play();
    }
  }
}

function mousePressed() {
}

function windowResized() {
}

// global callback from the settings GUI
function paramChanged(name) {
  if (name == "bins" || name == "smoothing") {
    initalizeAnalysis();
  }
}