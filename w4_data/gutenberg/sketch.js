/*
 * gutenberg - demos text processing
 *   Loads text from Project Gutenberg, processes it into 
 *   individual words, and plays the words in sequence as an animation. 
 */

// parameters
let p = {
  // opactity to draw each word
  alpha: 0.1,
  alphaMax: 0.2,
  alphaMin: 0.0,
  alphaStep:0.001,
  // interval of frames to update the string
  update: 16,
  updateMin: 1, 
  updateMax: 60,
  updateStep: 1,
}

// place all text here
let words
// word to display
let index = 0

function preload() {
  // you can also load from the web by giving a URL
   // let fn = "https://www.gutenberg.org/files/1342/1342-0.txt";
  let src = "data/1342-0.txt";

  // useful to print some messages to the console to track down bugs and 
  // problems with data sources
  print(`Loading '${src}'...`);
  let lines = loadStrings(src, function() {

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
  });
}

function setup() {
  createCanvas(600, 300)
  
  // add params to a GUI
  createParamGui(p, paramChanged);

  // simple HTML textarea debug window
  createDebugWindow();
  debug(words.join('\n'));

  background(0);  
 }

 function draw() {
   // semi transparent background to fade words
  background(0, p.alpha * 255);
 
  // text position
  let x = width/2;
  let y = height/2;

  // float the text up and down
  // let floatRange = 100;
  // y += -floatRange/2 + floatRange * noise(frameCount/500.0);

  // render the text
  fill(255);
  textSize(60);
  textAlign(CENTER, CENTER);  
  text(words[index], x, y);
  
  // simple timer method to do something every few frames
  if (frameCount % p.update == 0) {
    index++;
  }
}

// global callback from the settings GUI
function paramChanged(name) {
}



