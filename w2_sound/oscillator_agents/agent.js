

// First 8 patterns of Terry Riley's "In C"
const PATTERNS = [
  // 1
  [
    [NoteFrequency.C4, NoteType.ACCIACCATURA],
    [NoteFrequency.E4, NoteType.QUARTER_ACCIACCATURA],
    [NoteFrequency.C4, NoteType.ACCIACCATURA],
    [NoteFrequency.E4, NoteType.QUARTER_ACCIACCATURA],
    [NoteFrequency.C4, NoteType.ACCIACCATURA],
    [NoteFrequency.E4, NoteType.QUARTER_ACCIACCATURA],
  ],
  // 2
  [
    [NoteFrequency.C4, NoteType.ACCIACCATURA],
    [NoteFrequency.E4, NoteType.EIGHTH_ACCIACCATURA],
    [NoteFrequency.F4, NoteType.EIGHTH],
    [NoteFrequency.E4, NoteType.QUARTER],
  ],
  // 3
  [
    [NoteFrequency.E4, NoteType.EIGHTH],
    [NoteFrequency.F4, NoteType.EIGHTH],
    [NoteFrequency.E4, NoteType.EIGHTH],
  ],
  // 4
  [
    [NoteFrequency.E4, NoteType.EIGHTH],
    [NoteFrequency.F4, NoteType.EIGHTH],
    [NoteFrequency.G4, NoteType.EIGHTH],
  ],
  // 5
  [
    [NoteFrequency.E4, NoteType.EIGHTH],
    [NoteFrequency.F4, NoteType.EIGHTH],
    [NoteFrequency.G4, NoteType.EIGHTH],
    [NoteFrequency.REST, NoteType.EIGHTH],
  ],
  // 6
  [
    [NoteFrequency.C4, NoteType.WHOLE],
    [NoteFrequency.C4, NoteType.WHOLE],
  ],
  // 7
  [
    [NoteFrequency.REST, NoteType.QUARTER],
    [NoteFrequency.REST, NoteType.QUARTER],
    [NoteFrequency.REST, NoteType.QUARTER],
    [NoteFrequency.REST, NoteType.EIGHTH],
    [NoteFrequency.C4, NoteType.SIXTEENTH],
    [NoteFrequency.C4, NoteType.SIXTEENTH],
    [NoteFrequency.C4, NoteType.EIGHTH],
    [NoteFrequency.REST, NoteType.EIGHTH],
    [NoteFrequency.REST, NoteType.WHOLE],
  ],
  // 8
  [
    [NoteFrequency.G4, NoteType.DOTTED_WHOLE],
    [NoteFrequency.F4, NoteType.WHOLE],
    [NoteFrequency.F4, NoteType.WHOLE],
  ],
];


class Agent {
  osc;
  pattern;
  index;
  tick; // Number of QUANTIZATION steps so far
  frame; // Number of frames alive so far
  volume;
  noteEndTick; // Tick when current note will end

  // Drawing parameters
  x;
  y;
  hue;
  size;

  constructor() {
    this.pattern = 0;
    this.index = 0;
    this.tick = 0;
    this.frame = 0;

    const i = int(random(4));
    const type = ['sine', 'triangle', 'sawtooth', 'square'][i];
    const relVol = [1, 0.6, 0.25, 0.25][i]; // Balance perceived volume of different waveforms

    this.osc = new p5.Oscillator(type);
    this.env = new p5.Envelope();

    this.volume = BASE_VOLUME * relVol * random(0.5, 1);
    const pan = random(-1, 1);
    this.osc.pan(pan);
    this.env.setRange(this.volume, 0); // Set oscillator volume through envelope

    this.x = width / 2 * (1 + pan);
    this.y = random(height);
    this.hue = random(180, 260);

    this.playNote();
  }

  playNote() {
    // Update current note end tick
    const delta = PATTERNS[this.pattern][this.index][1] / QUANTIZATION;
    console.assert(delta === int(delta));
    this.noteEndTick = this.tick + delta;

    // Configure oscillator
    this.osc.stop();
    const freq = PATTERNS[this.pattern][this.index][0];
    if (freq !== NoteFrequency.REST) {
      const noteLen = frameInterval / FRAME_RATE * delta;
      // Give note a start and end (less robotic sounding):
      this.env.setADSR(
        p.noteAttackReleaseMs/1000,
        noteLen - 2 * p.noteAttackReleaseMs/1000,
        1,
        p.noteAttackReleaseMs/1000);
      this.osc.freq(freq);
      this.osc.start();
      this.env.play(this.osc);

      // Configure animation
      this.size = 0;
      const tl = gsap.timeline();
      tl.to(this, { size: 500 * this.volume * noteLen, duration: noteLen / 10, ease: 'power4.out' });
      tl.to(this, { size: 0, duration: noteLen / 10 * 9, ease: 'power4.in' });
    }
  }

  update() {
    if (this.pattern >= PATTERNS.length) {
      return;
    }

    this.frame++;

    if (this.frame % frameInterval == 0) {
      this.tick++;

      if (this.tick == this.noteEndTick) {
        // Loop through indices of current pattern
        this.index = (this.index + 1) % PATTERNS[this.pattern].length;

        // If end of current pattern, randomly advance to next
        if (this.index === 0 && random(1) < ADVANCE_PATTERN_CHANCE) {
          this.pattern++;

          // Stop playing if no more patterns
          if (this.pattern >= PATTERNS.length) {
            this.osc.stop();
            return;
          }
        }

        this.playNote();
      }
    }
  }

  draw() {
    noStroke();
    fill(this.hue, 50, 100);
    circle(this.x, this.y, this.size);
  }
}
