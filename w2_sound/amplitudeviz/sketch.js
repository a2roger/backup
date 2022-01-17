

// parameters
let p = {

  // fft smoothing
  smoothing: 0.8,
  smoothingMin: 0.01,
  smoothingMax: 0.99,
  smoothingStep: 0.01,

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
  sound.setLoop(true)

  initalizeAnalysis();
}

function initalizeAnalysis() {

  print(`amplitude with ${p.smoothing}`)
  if (amplitude == null) {
    // create a new amplitude analysis object
    amplitude = new p5.Amplitude(p.smoothing);
    amplitude.setInput(sound);
  }
  // parameters to tweak amplitude analysis
  amplitude.smooth(p.smoothing);
  // normalization
  amplitude.toggleNormalize(false);
}

// peak object 
let peak = {
  level: 0,
  opacity: 0,
}

function draw() {
  background(250);

  let level = amplitude.getLevel();

  // visualize amplitude
  let d = map(level, 0, 1, 0, height * 2);
  noStroke();
  fill(255, 0, 0, 100);
  circle(width / 2, height / 2, d);

  // visualize the highest peak in the last second

  // check if we have a new peak
  if (level > peak.level) {
    peak.level = level
    peak.opacity = 255
    // start new animation with callback function on completion
    // animated value "opacity" is a member of the object "peak"    
    // overwrite: true kills any animation already running
    gsap.to(peak, {
      opacity: 0,
      duration: 1.0,
      overwrite: true,
      onComplete: function () {
        print(`peak ${peak.level} completed`);
        peak.level = 0;
      }
    })
  }

  // render last peak
  noFill();
  stroke(255, 0, 0, peak.opacity);
  strokeWeight(2)
  circle(width / 2, height / 2, map(peak.level, 0, 1, 0, height * 2));

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