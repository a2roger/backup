class Agent {

  // current position
  float x;
  float y;

  // curve parameters
  float l = 1;
  float t;

  // stroke weight and shade
  float weight; 
  float shade;
  float hue;

  // maximum step size to take
  float maxStep = 0.01;
  // the probability % to turn
  float probTurn = 0.001;
  // base colour
  float baseHue = 0;

  // Sound file
  private AudioPlayer file;
  Sampler sample;
  AudioOutput out;
  Summer mix;
  Delay delay;
  LowPassSP lowPass;

  int soundTrigger;
  boolean isPlayingSound = false;

  // Aplitude Data
  //private Amplitude rms;
  float[] rms_buffer; 
  int num_points = 30;
  float rmsPrev = 0;
  float Y_Multiplier = 5;
  int num_lines = 1;
  float smooth_factor=1.0;
  int bufferIndex = 0;
  float Scale=100;

  // Interaction
  int agent_seen = 0;
  boolean is_interacting = false;
  Agent interacting_agent;
  float interaction_amount = 0;

  // create a new agent
  Agent(PApplet p, Minim minim, String filepath) {
    reset();

    // Load file
    file = minim.loadFile(filepath, 512);
    sample = new Sampler(filepath, 2, minim);
    mix = new Summer();
    out = minim.getLineOut();
    delay = new Delay(0.4, 0.5, true); //time, amplitude factor, feedback

    lowPass = new LowPassSP(0, file.sampleRate());
    file.addEffect(lowPass);
    lowPass.setFreq(20000);

    // patch
    sample.patch(mix);
    mix.patch(delay).patch(out);


    // Keep track of play length
    soundTrigger = millis();

    // Init buffer
    rms_buffer = new float[num_points];
    for (int i = 0; i < num_points; ++i) {
      rms_buffer[i] = 0.5;
    }
  }

  void play() {
    if (!isPlayingSound) {
      file.setGain(0.2);
      file.play();
      //sample.trigger(); 
      //file.play(1.0, 0.2);
      //rms.input(file);

      soundTrigger = millis() + ceil(file.length()); 
      isPlayingSound = true;
      lowPass.setFreq(map(agent_seen, 0, 10, 20000, 20));
      agent_seen++;
    }
  }

  void drawLine(Agent b, float w) {
    // Set interacting variables
    is_interacting = true;
    interacting_agent = b;
    interaction_amount = map(w, 0, 5, 0, 0.00001);
    
    // Draw line based on distance
    strokeWeight(w);
    line(x, y, b.x, b.y);
    
  }

  void update() {
    if (millis() > soundTrigger + 1000) {
      file.rewind();
      isPlayingSound = false;
    }


    float px = x;
    float py = y;

    // If the agent is interacting, do something
    if (is_interacting) {
      float _x = x + 1 * cos(t);
      float _y = y + 1 * sin(t);
      
      // calculate angle
      float deltaTheta = atan2(_x - px, _y - py) - atan2(interacting_agent.x - px, interacting_agent.y - py);
      probTurn += deltaTheta * interaction_amount;
    } 

    l += random(-maxStep, maxStep);
    x = x + l * cos(t);
    y = y + l * sin(t);


    line(px, py, x, y);
    ellipse(x, y, 3, 3);

    t += probTurn;

    // draw the line
    strokeWeight(weight);
    stroke(270, 100, shade, 33);
    line(px, py, x, y);

    // reset the agent if it leaves the canvas
    if (x < 0 || x > width - 1 || y < 0 || y > height - 1) {
      reset();
    }

    // reset the agent if it gets too big
    if (weight > 0.25 * height) {
      reset();
    }

    if (isPlayingSound) {

      // Get RMS level (0-1).
      float raw = file.left.level();

      // Low pass filter
      float rms = rmsPrev * (1 - smooth_factor) + raw * smooth_factor;  

      // rms.analyze() return a value between 0 and 1. It's
      float rms_scaled= rms * Scale;//rms*Scale;
      rmsPrev = rms;
      println(rms_scaled);

      // Draw visualization
      rms_buffer[bufferIndex] = rms_scaled;


      float prev_x, prev_y;
      float r = rms_scaled;
      float theta = radians(0);

      // Convert into cartesian coordinates
      prev_x = r * cos(theta) + x;
      prev_y = r * sin(theta) + y;

      for (int j = 0; j < num_points*4; ++j) {
        float cRms = rms_buffer[floor(j/4)] + random(0, 0.05);
        theta = radians(map(j, 0, num_points, 0, 360));

        for (int i = 0; i < num_lines; i++) {
          float y_offset = (i - num_lines/2) * Y_Multiplier;
          float colorval = map(y_offset, 0, 200, 270, 310);
          r = cRms + y_offset;

          // Convert into cartesian coordinates
          float x_tmp = r * cos(theta) + x;
          float y_tmp = r * sin(theta) + y;

          noStroke();
          fill(colorval, 100, 100);
          //ellipse(current.x + x_offset, current.y + y_offset, rms*50, rms*50);

          stroke(colorval, 100, 100);
          line(x_tmp, y_tmp, prev_x, prev_y);
          prev_x = x_tmp;
          prev_y = y_tmp;
          noStroke();
        }
      }
      // Increment Index
      bufferIndex++;
      if (bufferIndex >= num_points) bufferIndex = 0;
    } // ISSOUNDPLAYING

    
    is_interacting = false;
  }

  void reset() {
    float m = 0.02 * height; // margin
    x = random(m, width - m);
    y = random(m, height - m);
    t = random(TWO_PI);
    shade = random(0, 255);
    weight = 1;
    probTurn = 0.001;

    // pick a hue
    hue = (baseHue + random(0, 60)) % 360;
  }

  void draw() {
  }
}