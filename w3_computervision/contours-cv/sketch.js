// parameters
let p = {
  contour: true,
  hull: true,
  boundBox: true,
  threshold: 100,
  thresholdMin: 0,
  thresholdMax: 255,
  ksize: 3,
  ksizeMin: 1,
  ksizeMax: 40
}

const captureWidth = 640;
const captureHeight = 480;

// video capture
let video;

// Matrices to hold video data in OpenCV format
let videoMat = allocateMat(captureWidth, captureHeight);
let outputMat = allocateMat(captureWidth, captureHeight);


function setup() {
  createCanvas(640+160, 480)

  video = createCapture(VIDEO);
  video.size(captureWidth, captureHeight);

  // add params to a GUI
  createParamGui(p, paramChanged);

  // Hide the video element, and just show the canvas
  video.hide();
}

function draw() {
  background(255);

  noStroke();
  fill('#0000aa');
  rect(captureWidth, captureHeight-120, 160, 120);
  // Draw a little preview of the raw camera feed
  image(video, captureWidth, captureHeight-120, 160, 120);

  let videoImg = video.get();
  // Convert the current video frame to a matrix and store it in videoMat
  imageToMat(videoImg, videoMat);

  // Convert videoMat to greyscale and store it in outputMat
  // NOTE: In principle, we only need one matrix for both the input and the
  //       output, but this doesn't seem to work.
  cv.cvtColor(videoMat, outputMat, cv.COLOR_RGBA2GRAY);

  // Apply a blur to outputMat. Using a higher blur value smooths the edges
  // of detected contours, and helps prevent tiny noise-like contours from
  // being detected.
  if (p.ksize > 1) {
    cv.blur(outputMat, outputMat, new cv.Size(p.ksize, p.ksize));
  }

  // Apply a threshold filter to outputMat so that the contour detection can
  // work.
  cv.threshold(outputMat, outputMat, p.threshold, 255, cv.THRESH_BINARY);

  // Convert outputMat back into a p5 image so we can see the result of the
  // filters.
  let outputImg = matToNewImage(outputMat);
  image(outputImg, 0, 0);

  strokeWeight(4);
  noFill();

  let hierarchy = new cv.Mat();
  let contours = new cv.MatVector();
  // Find the contours in outputMat and store them in contours.
  // The hierarchy variable is not used here.
  // NOTE: You can also find nested contours by tweaking the 4th parameter.
  cv.findContours(outputMat, contours, hierarchy,
                  cv.RETR_EXTERNAL, cv.CHAIN_APPROX_SIMPLE);

  for (let i = 0; i < contours.size(); i++) {
    let c = contours.get(i);

    // Contour itself
    if (p.contour) {
      drawContour(c);
    }

    // Convex hull
    if (p.hull) {
      drawHull(c);
    }

    // Bounding box
    if (p.boundBox) {
      drawBoundBox(c);
    }
  }

  // Need to delete unused matrices, because opencv doesn't do this automatically.
  // IMPORTANT: If you create matrices ("new Mat") in draw() without deleting
  //            them after use, the browser will run out of memory and your
  //            code will crash!
  hierarchy.delete();
  contours.delete();

  // debug info
  drawFps();
}

function drawContour(c) {
  stroke(255, 0, 0);

  // c.data32S is an array of all the points in the contour. It's stored
  // as a 1D array in the format [x0, y0, x1, y1, ...], so we iterate by
  // twos to get out the corresponding x&y points to draw.
  beginShape();
  for (let i = 0; i < c.data32S.length; i+=2) {
    vertex(c.data32S[i], c.data32S[i+1])
  }
  endShape();
}

function drawHull(c) {
  stroke(0, 255, 0);

  // Make a matrix (used as a list of points) to store the hull points
  let hullpts = new cv.Mat();

  // 3rd parameter is unlikely to be relevant,
  // 4th parameter indicates to store the hull points in the hullpts matrix.
  cv.convexHull(c, hullpts, false, true);

  beginShape();
  // See comment in drawContour() for how this works.
  for (let i = 0; i < hullpts.data32S.length; i+=2) {
    vertex(hullpts.data32S[i], hullpts.data32S[i+1]);
  }
  endShape();

  // Remember to delete unused matrices
  hullpts.delete();
}

function drawBoundBox(c) {
  stroke(0, 0, 255);

  // Get the bounding rect of the contour and draw it
  let r = cv.boundingRect(c);
  rect(r.x, r.y, r.width, r.height);
}

// global callback from the settings GUI
function paramChanged(name) {
}


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

