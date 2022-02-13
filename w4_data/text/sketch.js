/*
 * text data demo
 *   Loads text and prints it to the console. 
 */

// parameters
let p = {
  boolean: true,
  numeric: 50,
  numericMin: 0,
  numericMax: 100,
  numericStep: 1,
}

// place all text here
let text = ''

function preload() {
  // you can also load from the web by giving a URL
  // let fn = "https://www.gutenberg.org/files/1342/1342-0.txt";
  // this file better tbe in the /data subdirectory
  let fn = "data/1342-0.txt";

  // useful to print some messages to the console to track down bugs and 
  // problems with data sources
  print(`Loading '${fn}'...`);
  let lines = loadStrings(fn, function() {
    print(`  loaded ${lines.length} lines`);  
    // loadStrings returns an array containing each line of the text file
    // if you want to whole file as one big string (with new line chars too),
    // join the lines back into one big string (with new lines inserted)
    text = lines.join('\n');
  });
}

function setup() {
  createCanvas(500, 100)
  
  // add params to a GUI
  createParamGui(p, paramChanged);
  _paramGui.hide()

  // can print everything to the console
  print(text);

  // but often nice to display in HTML textarea
  let ta = createElement('textarea')
  ta.style('min-width: 700px; height: 400px; padding: 20px; margin: 20px;')
  ta.html(text);

 }

function draw() {
  background(240)
 
}

function keyPressed() {
  if (key == ' ') {
  }
}

function mousePressed() {
}

function windowResized() {
}

// global callback from the settings GUI
function paramChanged(name) {
}



