

// parameters
let p = {
  // toggle your effects
  oscillator: ['sine', 'square', 'triangle', 'sawtooth'],

  amp: 0.3,
  ampMin: 0,
  ampMax: 1,
  ampStep: 0.1,


  freq: 440,
  freqMin: 65,
  freqMax: 2093,
}

// our oscillator
let osc

function setup() {
  createCanvas(250, 250)

  // add params to a GUI
  createParamGui(p, paramChanged);

  // create an oscillator 
  osc = new p5.Oscillator(p.oscillator)
  osc.freq(p.freq)
  osc.amp(p.amp)
}

function draw() {
  background(250);
  textAlign(CENTER, CENTER)
  text("SPACE to Play/Pause", width/2, height/2)

  // if (isPlaying)
  //   osc.freq(p.freq, 0.1)
}

let isPlaying = false;

function keyPressed() {
  if (key == " ") {
    if (!isPlaying) {
      osc.start()
      osc.amp(p.amp)  
    } else
      osc.stop()
    isPlaying = !isPlaying
  }
}

function mousePressed() {


}

// global callback from the settings GUI
function paramChanged(name) {

  if (name == "freq") {
    osc.freq(p.freq)
  } else if (name == "amp") {
    osc.amp(p.amp)
  } else if (name == "oscillator") {
    // need to stop current oscillator or else it
    // will keep running in the background
    osc.stop()

    // create new oscillator
    osc = new p5.Oscillator(p.oscillator)
    osc.amp(0.5)

    // start it if already playing
    if (isPlaying)
      osc.start()
  }
}