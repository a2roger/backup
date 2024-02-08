// parameters
let p = {
  boundBox: true,
  annotations: false,
  landmarks: false,
};

// the model
let handpose;
// latest model predictions
let predictions = [];
// video capture
let video;

function preload() {}

function setup() {
  createCanvas(640, 480);

  video = createCapture(VIDEO);
  video.size(width, height);

  // add params to a GUI
  createParamGui(p, paramChanged);

  // initialize the model
  handpose = ml5.handpose(video, modelReady);

  // This sets up an event that fills the global variable "predictions"
  // with an array every time new predictions are made
  handpose.on("predict", (results) => {
    predictions = results;
  });

  // Hide the video element, and just show the canvas
  video.hide();
}

function modelReady() {
  console.log("Model ready!");
}

function draw() {
  background("#0000cc");
  image(video, 0, 0, width, height);

  // different visualizations
  if (p.boundBox) drawBoundingBoxes();
  if (p.landmarks) drawLandmarks();
  if (p.annotations) drawAllAnnotations();

  // if (predictions.length > 0) {
  //   drawAnnotation(predictions[0], "silhouette")
  // }

  // debug info
  drawFps();
}

// draw bounding boxes around all detected hands
function drawBoundingBoxes() {
  let c = "#ff0000";

  predictions.forEach((p) => {
    const bb = p.boundingBox;
    // get bb coordinates
    const x = bb.topLeft[0];
    const y = bb.topLeft[1];
    const w = bb.bottomRight[0] - x;
    const h = bb.bottomRight[1] - y;

    // draw the bounding box
    stroke(c);
    strokeWeight(2);
    noFill();
    rect(x, y, w, h);
    // draw the confidence
    noStroke();
    fill(c);
    textAlign(LEFT, BOTTOM);
    textSize(20.0);
    text(p.handInViewConfidence.toFixed(2), x, y - 10);
  });
}

/* list of annotations:      
thumb
indexFinger
middleFinger
ringFinger
pinky
palmBase
*/

function drawAnnotation(prediction, name, color = "#0000ff") {
  let pts = prediction.annotations[name];
  if (pts.length == 1) {
    const [x, y] = pts[0];
    noStroke();
    fill(color);
    ellipse(x, y, 12);
  } else {
    let [px, py] = pts[0];
    for (let i = 1; i < pts.length; i++) {
      const [x, y] = pts[i];
      stroke(color);
      strokeWeight(4);
      noFill();
      line(px, py, x, y);
      px = x;
      py = y;
    }
  }
}

function drawAllAnnotations() {
  predictions.forEach((p) => {
    let keyNum = Object.keys(p.annotations).length;
    let i = 0;
    for (let n in p.annotations) {
      // make a rainbow
      let hue = map(i++, 0, keyNum, 0, 360);
      let c = color(`hsb(${hue}, 100%, 100%)`);
      // draw the annotation
      drawAnnotation(p, n, c);
    }
  });
}

// Draw dots for all detected landmarks
function drawLandmarks() {
  predictions.forEach((p) => {
    const landmarks = p.landmarks;

    for (let k of landmarks) {
      const [x, y] = k;

      stroke(128);
      strokeWeight(1);
      fill(255);
      ellipse(x, y, 10, 10);
    }
  });
}

function keyPressed() {
  if (key == "?") {
    if (predictions) print(JSON.stringify(predictions, null, 2));
  } else if (key === "a") {
    if (predictions) {
      for (a in predictions[0].annotations) {
        print(a);
      }
    }
  }
}

function mousePressed() {}

function windowResized() {}

// global callback from the settings GUI
function paramChanged(name) {}

fps = 0;

function drawFps() {
  let a = 0.01;
  fps = a * frameRate() + (1 - a) * fps;
  stroke(255);
  strokeWeight(0.5);
  fill(0);
  textAlign(LEFT, TOP);
  textSize(20.0);
  text(this.fps.toFixed(1), 10, 10);
}
