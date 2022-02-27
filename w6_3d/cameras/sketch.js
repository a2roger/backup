/*
 * cameras demo
 *   Control of a virtual 3D camera.
 */

// Camera parameters
let camDist = 0;
let originX = 0;
let camRoll = 0;

function setup() {
  createCanvas(300, 300, WEBGL);
}

function draw() {
  background(0);

  lights();

  camera(0, -100, camDist,
         originX, 0, 0,
         sin(camRoll), cos(camRoll), 0);

  // ACTION!

  if (keyIsPressed && key == '1') {
      perspective(
        map(mouseY, 0, height, 0, PI),
        width/height,
        1, 1000);
  } else {
      camDist = mouseY * 3;
  }

  if (keyIsPressed && key == '2') {
    camRoll = map(mouseX, 0, width, -HALF_PI, HALF_PI);
  } else {
    originX = map(mouseX, 0, width, -100, 100);
  }

  // Draw a box on a plane
  noStroke();
  fill("#668888");
  box(300, 1, 300);
  translate(0, -25, 0);
  fill("#887766");
  box(50);
}
