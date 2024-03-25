// parameters
let p = {
  boundBox: false,
  annotations: true,
  landmarks: false,
};

let testB = true;
let window1 = true;
let window2 = true;
let window3 = true;
let window4 = true;
let window5 = true;
// the model
let handpose;
// latest model predictions
let predictions = [];
// video capture
let video;
let stinky;
let windowX = 50;
let windowY = 50;

let sound;
let soundFFT;

let pointy;
let folder;
let trash;
let Web;
let computer;
let neoJam;
let photoChat;
let computerBackground
let appWindow;
let taskBar;
let redOrb;
let backGround;
let wText;
let mText;
let pcText;
let fText;
let rText;
let cText;
let slector;

let wind1;
let wind2;
let wind3;
let wind4;
let wind5;

let newsHeadlines;

let newsTitle;
let photoPeople;
let addCaption;
let record; 
let err;



let corruptionCounter = 1000;
let checker = 0;
let squareX = [];
let xAdvance = 0;
let yAdvance = 0;
let squareY = [];

function preload() {
  // change the directory or filename prefix as needed

  pointy = loadImage("data/pointer.png");
  backGround = loadImage("data/computer background.png");

  folder = loadImage("data/folder.png");
  computer = loadImage("data/computer.png");
  trash = loadImage("data/trash bin.png");
  Web = loadImage("data/Web Browser.png");
  neoJam = loadImage("data/Neo-Jam.png");
  photoChat = loadImage("data/Photo-Chat.png");
  appWindow = loadImage("data/window.png");

  wind1 = loadImage("data/window2.png");
  wind2 = loadImage("data/window3.png");
  wind3 = loadImage("data/big window.png");
  wind4 = loadImage("data/big big window.png");
  wind5 = loadImage("data/big big window.png");

  wText = loadImage("data/web text.png");
  rText = loadImage("data/reycle text.png");
  fText = loadImage("data/files text.png");
  cText = loadImage("data/computer text.png");
  mText = loadImage("data/Jammer.png");
  pcText = loadImage("data/photo-chat text.png");

  newsTitle = loadImage("data/news.png");
  newsHeadlines = loadImage("data/news headlines.png");
  addCaption = loadImage("data/Caption.png");
  record = loadImage("data/textBox.png");
  photoPeople = loadImage("data/people.png");
  err = loadImage("data/error.png");

  taskBar = loadImage("data/task bar.png");
  redOrb = loadImage("data/little red guy.png");
  slector = loadImage("data/slector.png");
};

function modelLoaded(){
  console.log('handpose ready');
}


function setup() {
  createCanvas(960, 720);

  video = createCapture(VIDEO);
  video.size(40, 30);
  // add params to a GUI
  createParamGui(p, paramChanged);

  // initialize the model
  handpose = ml5.handpose(video, modelLoaded);

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
  image(backGround, 0, 0, 1200, height);
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
    ellipse(x * 1.5, y * 1.5, 12);
  } else {
    let [px, py] = pts[0];
    for (let i = 1; i < pts.length; i++) {
      const [x, y] = pts[i];
      stroke(color);
      strokeWeight(4);
      noFill();
      line(px * 1.5, py * 1.5, x * 1.5, y * 1.5);
      px = x;
      py = y;
    }
  }
}

function drawAllAnnotations() {
  image(Web, 30, 55, 100, 100);
  image(computer, 35, 205, 100, 100);
  image(folder, 24, 365, 120, 100);
  image(trash, 30, 525, 100, 110);

  image(neoJam, 800, 200, 130, 120);
  image(photoChat, 795, 370, 140, 130);

  image(wText, 26, 150, 120, 35);
  image(cText, 40, 308, 80, 24);
  image(fText, 47, 465, 80, 25);
  image(rText, 50, 640, 80, 27);
  image(mText, 815, 330, 100, 35);
  image(pcText, 815, 495, 100, 35);

  image(taskBar, 890, 25, 30, 110);

  if(testB === false){
    image(appWindow, 250, 75, 300, 250);
    image(newsTitle, 335, 105, 125, 50);
    image(newsHeadlines, 265, 160, 185, 150);
  };
  if(window1 === false){
    image(wind1, 500, 200, 300, 250);
    image(err, 565, 250, 250, 200);
  };
  if(window2 === false){
    image(wind3, 200, 105, 495, 385);
    image(err, 260, 235, 250, 200);
  };
  if(window3 === false){
    image(wind4, 175, 300, 700, 620);
    image(err, 350, 500, 250, 200);
  };
  if(window4 === false){
    image(wind5, 100, 67, 700, 620);
    frameRate(5);
    image(video, 200, 122, 500, 400);
    image(addCaption, 140, 540, 100, 30);
  } else if(window4 === true){
    frameRate(30);
  }
  if(window5 === false){
    image(wind2, 195, 135, 700, 510);
    image(video, 230, 175, 300, 250);
    image(record, 670, 190, 150, 85);
    image(record, 670, 300, 150, 85);
    image(addCaption, 560, 400, 100, 30);
    image(photoPeople, 560, 185, 100, 200);

  };

  predictions.forEach((p) => {

    let midFingy = predictions[0].annotations['indexFinger'][3];
    let thumb = predictions[0].annotations['thumb'][3];

    let fingerX = midFingy[0] * 1.5;
    let fingerY = midFingy[1] * 1.5;

    let thumbX = thumb[0] * 1.5;
    let thumbY = thumb[1] * 1.5;

    line(thumbX, thumbY, fingerX, fingerY);

    let keyNum = Object.keys(p.annotations).length;
    let i = 0;

    
    for (let n in p.annotations) {
      // make a rainbow
      let hue = map(i++, 0, keyNum, 0, 360);
      let c = color(`hsb(${hue}, 100%, 100%)`);
      // draw the annotation
      drawAnnotation(p, n, c);
    }


    if(thumbX <= fingerX + 30  && thumbY <= fingerY + 30 && thumbX >= fingerX - 30  && thumbY >= fingerY - 30){


    if(thumbX <= 130 && thumbX >= 30 && thumbY <= 190 && thumbY >= 55){
      testB = false;
    } else if(thumbX <= 560 && thumbX >= 540 && thumbY <= 100 && thumbY >= 70){
      testB = true;
    }

    if(fingerX <= 130 && fingerX >= 30 && fingerY <= 335 && fingerY >= 195){
      window1 = false;
    } else if(thumbX <= 810 && thumbX >= 790 && thumbY <= 95 && thumbY >= 70){
      window1 = true;
    }
    
    if(fingerX <= 130 && fingerX >= 30 && fingerY <= 475 && fingerY >= 350){
      window2 = false;
    } else if(thumbX <= 700 && thumbX >= 680 && thumbY <= 125 && thumbY >= 105){
      window2 = true;
    }
    
    if(fingerX <= 130 && fingerX >= 30 && fingerY <= 655 && fingerY >= 525){
      window3 = false;
    } else if(thumbX <= 885 && thumbX >= 860 && thumbY <= 320 && thumbY >= 300){
      window3 = true;
    }
    
    if(fingerX <= 935 && fingerX >= 800 && fingerY <= 370 && fingerY >= 215){
      window4 = false;
    } else if(thumbX <= 805 && thumbX >= 785 && thumbY <= 82 && thumbY >= 67){
      window4 = true;
    }
    
    if(fingerX <= 935 && fingerX >= 800 && fingerY <= 515 && fingerY >= 375){
      window5 = false;
    } else if(thumbX <= 910 && thumbX >= 890 && thumbY <= 145 && thumbY >= 130){
      window5 = true;
    }
    } 

  
  line(thumbX, thumbY, fingerX, fingerY);
  image(redOrb, thumbX - 25, thumbY - 25, 50, 50);
  image(redOrb, fingerX + 25, fingerY + 25, -50, -50);

  if(fingerX <= 130 && fingerX >= 30 && fingerY <= 190 && fingerY >= 55){
    image(slector, 25, 50, 115, 130);
  } else if(fingerX <= 130 && fingerX >= 30 && fingerY <= 335 && fingerY >= 195){
    image(slector, 25, 195, 115, 145);
  } else if(fingerX <= 130 && fingerX >= 30 && fingerY <= 475 && fingerY >= 350){
    image(slector, 25, 350, 115, 145);
  } else if(fingerX <= 130 && fingerX >= 30 && fingerY <= 655 && fingerY >= 525){
    image(slector, 25, 525, 115, 145);
  } else if(fingerX <= 935 && fingerX >= 800 && fingerY <= 370 && fingerY >= 215){
    image(slector, 800, 190, 115, 170);
  } else if(fingerX <= 935 && fingerX >= 800 && fingerY <= 515 && fingerY >= 375){
    image(slector, 800, 375, 125, 150);
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
