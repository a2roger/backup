/*
 * models in 3D demo
 *   Render and texture loaded 3D models.
 */


let tree;
let texs = [];
let texIdx = 0;

let drawMultiple = false;


function preload() {
  tree = loadModel("data/tree.obj");
  texs.push(loadImage("data/tree_texture.jpg"));
  texs.push(loadImage("data/tree_texture_alternate.jpg"));
}

function setup() {
  // need to set the "renderer" to WEBGL
  createCanvas(800, 400, WEBGL);
}

// Draws one tree with the correct scale and rotation
function drawTree() {
  push();
  scale(30);
  rotateZ(PI);
  texture(texs[texIdx]);
  model(tree);
  pop();
}

function draw() {
  background(128, 200, 255);

  noStroke();
  fill(100, 150, 50);
  rect(-width/2, height/4, width, height/4);

  translate(0, height/4, 0);
  if (!drawMultiple) {
    drawTree();
  } else {
    for (let i = -5; i < 5; i++) {
      push();
      translate(i*50, 0, noise(i)*200);
      drawTree();
      pop();
    }
  }
}

function keyPressed() {
  if (key == 'c') {
    texIdx = (texIdx + 1) % texs.length;
  }
  if (key == 'm') {
    drawMultiple = !drawMultiple;
  }
}
