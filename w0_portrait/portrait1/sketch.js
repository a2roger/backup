// IMPORTANT! set you frameNum 
let frameNum = 16;

let images = [];

function preload() {
  // change the directory or filename prefix as needed
  for (i = 0; i < frameNum; i++) {
    let fn = 'data/frame' + (i+1) + ".png"
    print(fn)
    images.push(loadImage(fn))
  }
}

function setup() {
  createCanvas(256, 256);
  background(0);  
}

function draw() {
   
  // remap mouseX to the legal frame range
  let i = int(map(mouseX, width, 0, 0, frameNum - 1))
  // make sure our mapped index stays in the range
  i = constrain(i, 0, frameNum - 1)
  
  // draw the image for corresponding frame
  image(images[i], 0, 0)
  
}

