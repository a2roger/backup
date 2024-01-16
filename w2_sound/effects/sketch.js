// parameters
let p = {
  // toggle your effects
  effects: false,

  clipLength: 2,
  clipLengthMin: 0.5,
  clipLengthMax: 10,
  clipLengthStep: 0.5,
};

let mic; // p5.AudioIn object to capture the mic
let clip; // p5.SoundFile we record to
let recorder; // p5.SoundRecorder that does the recording

function setup() {
  createCanvas(250, 250);

  // add params to a GUI
  createParamGui(p, paramChanged);

  // setup mic capture
  mic = new p5.AudioIn();
  mic.start();

  // create a sound recorder
  recorder = new p5.SoundRecorder();
  recorder.setInput(mic);

  // create an empty sound file to record to
  clip = new p5.SoundFile();
}

let isRecording = false;

function draw() {
  background(250);

  textAlign(CENTER, CENTER);
  text("SPACE to Record Clip", width / 2, height / 2);

  if (isRecording) {
    push();
    noFill();
    stroke("#FF0000");
    strokeWeight(5);
    rect(0, 0, width - 1, height - 1);
    pop();
  }
}

function keyPressed() {
  userStartAudio();
  if ((key = " ")) {
    clip.stop();
    print("RECORD Start");
    isRecording = true;
    recorder.record(clip, p.clipLength, recordingDone);
  }
}

// callback function called after the recording finishes
function recordingDone() {
  print("RECORD End");
  isRecording = false;
  clip.loop();
}

let effect;

// global callback from the settings GUI
function paramChanged(name) {
  if (name == "effects") {
    if (p.effects) {
      // Delay
      effect = new p5.Delay();
      effect.process(clip, 0.12, 0.7, 2300);
      // Distortion
      // effect = new p5.Distortion();
      // effect.process(clip, 0.25, 'x2');
      // Reverb
      // effect = new p5.Reverb();
      // effect.process(clip, 3, 2);
    } else {
      // turn off effect
      effect.disconnect();
    }
  }
}
