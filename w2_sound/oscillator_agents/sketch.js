

// parameters
let p = {
  bpm: 100,
  bpmMin: 40,
  bpmMax: 200,

  noteAttackReleaseMs: 20,
  noteAttackReleaseMsMin: 1,
  noteAttackReleaseMsMax: 50,
};

let agents = [];

// Constants
const SECS_PER_MIN = 60;
const FRAME_RATE = 60;
const BEATS_PER_BAR = 4;
const QUANTIZATION = NoteType.THIRTY_SECOND;

// Parameters
const NUM_AGENTS = 35;
const ADVANCE_PATTERN_CHANCE = 0.2;
const BASE_VOLUME = 0.05;

// Closest interval that aligns QUANTIZATION with frame rate
let frameInterval;

function setup() {
  createCanvas(400, 400);

  // add params to a GUI
  createParamGui(p, paramChanged);

  colorMode(HSB);
  textAlign(CENTER, CENTER);
}

function draw() {
  background(250);

  if (agents.length === 0) {
    fill(0);
    text("SPACE to Start", width / 2, height / 2);
  }

  frameInterval = round(FRAME_RATE / (p.bpm * (NoteType.QUARTER / QUANTIZATION) / SECS_PER_MIN));

  for (const a of agents) {
    a.update();
    a.draw();
  }
}

function keyPressed() {
  if (key === " " && agents.length === 0) {
    for (let i = 0; i < NUM_AGENTS; i++) {
      agents.push(new Agent());
    }
  }
}

// global callback from the settings GUI
function paramChanged(name) {
}