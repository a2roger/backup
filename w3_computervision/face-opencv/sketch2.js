/**
 * OpenCV 4 in p5.js: Blur example
 */

// p5.js Video capture
let myCapture;
// OpenCV capture helper
let myCVCapture;
// (RGBA) Mat to store the latest color camera frame
let rgba;
// Mat to store the grayscale converted camera frame
let gray;
// Mat to store threshold result
let myMatThresh;

// Blur properties
let useGaussian = false;
let radius = 12;

function setup() {
  createCanvas(640, 240);
  // setup p5 capture
  myCapture = createCapture(VIDEO);
  myCapture.size(320, 240);
  myCapture.hide();
  // wait for OpenCV to init
  p5.cv.onComplete = onOpenCVComplete;
}

let classifier;
let faces;

function onOpenCVComplete() {
  // create a CV capture helper
  myCVCapture = p5.cv.getCvVideoCapture(myCapture);
  // create a CV Mat to read new color frames into
  rgba = p5.cv.getRGBAMat(320, 240);
  // create a CV mat for color to grayscale conversion
  gray = new cv.Mat();
  // create a CV mat for thersholding
  myMatThresh = new cv.Mat();

  classifier = new cv.CascadeClassifier();
  classifier.load('data/haarcascade_frontalface_default.xml');  

  faces = new cv.RectVector();

  print("done onOpenCVComplete")
}

function draw() {
  if (p5.cv.isReady) {
    // read from CV Capture into myMat
    myCVCapture.read(rgba);
    // convert Mat to grayscale
    // p5.cv.copyGray(rgba, gray);
    cv.cvtColor(rgba, gray, cv.COLOR_RGBA2GRAY, 0)
    // if (frameCount > 180) {
      // classifier.detectMultiScale(gray, faces, 1.1, 3, 0);    
      // display Mat
      p5.cv.drawMat(gray, 0, 0);
    // }
  } else {
    image(myCapture, 0, 0);
  }
}

function draw2() {
  if (p5.cv.isReady) {
    // read from CV Capture into myMat
    myCVCapture.read(rgba);
    // convert Mat to grayscale
    p5.cv.copyGray(rgba, gray);
    // apply threshold
    if(mouseIsPressed) {
			p5.cv.autothreshold(gray);
		} else {
			let thresholdValue = map(constrain(mouseX, 0, width), 0, width, 0, 255);
			p5.cv.threshold(gray, thresholdValue);
		}
    // display Mat
    p5.cv.drawMat(rgba, 0, 0);
    p5.cv.drawMat(gray, 320, 0);

  } else {
    image(myCapture, 0, 0);
  }
}