// parameters
let p = {
  annotations: true,
  landmarks: false,
  skeleton: false,
};

// the model
let posenet;
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
  posenet = ml5.poseNet(video, modelReady);

  // This sets up an event that fills the global variable "predictions"
  // with an array every time new predictions are made
  posenet.on("pose", (results) => {
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
  if (p.landmarks) drawLandmarks();
  if (p.annotations) drawAllAnnotations();
  if (p.skeleton) drawSkeleton();

  // if (predictions.length > 0) {
  //   drawAnnotation(predictions[0], "silhouette")
  // }

  // debug info
  drawFps();
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
  let a = prediction.pose[name];
  const x = a.x;
  const y = a.y;
  noStroke();
  fill(color);
  ellipse(x, y, 12);
}

function drawAllAnnotations() {
  predictions.forEach((p) => {
    let keyNum = Object.keys(p.pose).length;
    let i = 0;
    for (let n in p.pose) {
      if (n == "keypoints" || n == "score") continue;
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
    const landmarks = p.pose.keypoints;

    landmarks.forEach((k) => {
      const x = k.position.x;
      const y = k.position.y;

      stroke(128);
      strokeWeight(1);
      fill(255);
      ellipse(x, y, 10, 10);
    });
  });
}

// A function to draw the skeletons
function drawSkeleton() {
  // Loop through all the skeletons detected
  predictions.forEach((_, i) => {
    let skeleton = predictions[i].skeleton;
    // For every skeleton, loop through all body connections
    skeleton.forEach((_, j) => {
      // make a rainbow
      let hue = map(j, 0, 20, 0, 360);
      let c = color(`hsb(${hue}, 100%, 100%)`);

      let partA = skeleton[j][0];
      let partB = skeleton[j][1];
      strokeWeight(10);
      stroke(c);
      line(
        partA.position.x,
        partA.position.y,
        partB.position.x,
        partB.position.y
      );
    });
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
