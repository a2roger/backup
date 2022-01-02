

// parameters
let p = {
  // toggle filling screen or not
  spectrum: true,
  waveform: true,
  centroid: true,
  energy: true,

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
let soundFFT;

function preload() {
  sound = loadSound("data/mecha-action.mp3")
}

function setup() {
  createCanvas(600, 300)

  // add params to a GUI
  createParamGui(p, paramChanged);

  // sound.play()
  // sound.setLoop(true)
  sound = new p5.AudioIn()
  sound.start()

  initalizeAnalysis();
}

function initalizeAnalysis() {
  print(`creating FFT with ${2 ** p.bins} bins`)
  soundFFT = new p5.FFT(p.smoothing, 2 ** p.bins);
  soundFFT.setInput(sound);
}

function draw() {

  background(250);

  let spectrum = soundFFT.analyze();

  // spectrum is grey bars
  if (p.spectrum) {
    noStroke();
    fill(120);
    for (let i = 0; i < spectrum.length; i++) {
      let x = map(i, 0, spectrum.length, 0, width);
      let h = -height + map(spectrum[i], 0, 255, height, 0);
      rect(x, height, width / spectrum.length, h)
    }
  }

  // waveform is black line
  if (p.waveform) {
    let waveform = soundFFT.waveform();
    noFill();
    beginShape();
    stroke(20);
    strokeWeight(4);
    for (let i = 0; i < waveform.length; i++) {
      let x = map(i, 0, waveform.length, 0, width);
      let y = map(waveform[i], -1, 1, 0, height);
      vertex(x, y);
    }
    endShape();
  }

  // spectral centroid visualized as red bar
  if (p.centroid) {

    let spectralCentroid = soundFFT.getCentroid();
    // the mean_freq_index calculation is for the display.
    let nyquist = 22050;
    let mean_freq_index = spectralCentroid / (nyquist / spectrum.length);
    let centroidplot = map(log(mean_freq_index), 0, log(spectrum.length), 0, width);
    fill(255, 0, 0, 200); 
    noStroke();
    rect(centroidplot, 0, width / spectrum.length, height)
  }

  // frequency band energy visualized as red circles
  if (p.energy) {
    let energy = [
      soundFFT.getEnergy("bass"),
      soundFFT.getEnergy("lowMid"),
      soundFFT.getEnergy("mid"),
      soundFFT.getEnergy("highMid"),
      soundFFT.getEnergy("treble"),
    ]
    energy.forEach(function (v, i) {
      let x = map(i, 0, energy.length - 1, 50, width - 50);
      let y = map(v, 0, 255, height, 0)
      let d = map(i, 0, energy.length - 1, 80, 30)
      fill(255, 0, 0, 100);       
      circle(x, y, d);
    });
  }
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