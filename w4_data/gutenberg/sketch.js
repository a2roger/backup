/*
 * gutenberg - demos text processing
 *   Loads text from Project Gutenberg, processes it into 
 *   individual words, and plays the words in sequence as an animation. 
 */

// parameters
let p = {
}

// place all text here
let words
let index = 0

function preload() {
  // you can also load from the web by giving a URL
   // let fn = "https://www.gutenberg.org/files/1342/1342-0.txt";
  let fn = "data/1342-0.txt";

  // useful to print some messages to the console to track down bugs and 
  // problems with data sources
  print(`Loading '${fn}'...`);
  let lines = loadStrings(fn, function() {

    print(`  loaded ${lines.length} lines`);  
  
    // I looked at the file, and found this frontmatter text comes
    // right before the actual book text. It seems to be different for 
    // each file (or at least different types of books)
    let start = "Chapter 61";

    // strip out gutenberg frontmatter and endmatter
    let s = ''
    let frontmatter = true;
    for (l of lines) {
      if (frontmatter && l.includes(start)) {
        frontmatter = false;
      } else if (!frontmatter) {
        s += l + " "
      }
    }
    print(`  found ${s.length} characters in book`);

    // split on whitespace to get individual words
    words = splitTokens(s, " ");
    print(`  found ${words.length} words in book`);

    // text = lines.join('\n');
  });
}

function setup() {
  createCanvas(600, 300)
  
  // add params to a GUI
  createParamGui(p, paramChanged);
  _paramGui.hide()

  // but often nice to display in HTML textarea
  let ta = createElement('textarea')
  ta.style('min-width: 700px; height: 400px; padding: 20px; margin: 20px;')
  
  ta.html(words.join('\n'));

  background(0);  
 }

 function draw() {
  // background(0);
  let alpha = adjustY(0, 50); // 10 looks nice

  // black rect to fade out text
  fill(0, alpha);
  rect(0, 0, width, height);
  
  // text position
  let x = width/2;
  let y = height/2;

  // float the text up and down
  let floatRange = 100;
  y += -floatRange/2 + floatRange * noise(frameCount/500.0);

  // render the text
  fill(255);
  textSize(60);
  textAlign(CENTER, CENTER);  
  text(words[index], x, y);
  
  // interval of frames to update the string
  let update = int(adjustX(1, 60)); // ~16 looks nice
  
  // simple timer method to do something every few frames
  if (frameCount % update == 0) {
    index++;
  }
}


// helper functions to adjust values with mouse

function adjustX(low, high) {
   let v = map(mouseX, 0, width - 1, low, high); 
   print(`adjustX: $v`);
   return v;
}

function adjustY(low, high) {
   let v = map(mouseY, 0, height - 1, low, high); 
   print(`adjustY: $v`);
   return v;
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



