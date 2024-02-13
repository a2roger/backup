/*
 * text data demo
 *   Loads text and prints it to the console.
 */

// place all text here
let all = "";

function preload() {
  // load file from /data subdirectory
  let src = "data/1342-0.txt";

  // you can also load from the web by giving a URL
  // let src = "https://www.gutenberg.org/cache/epub/158/pg158.txt";
  // IMPORTANT! loading from remote files will cause "CORS" error
  // until you allow it in your browser

  // useful to print some messages to the console to track down bugs and
  // problems with data sources
  print(`Loading '${src}'...`);

  // loadStrings returns an array containing each line of the text file
  // the second argument is a callback function to execute after load
  let lines = loadStrings(src, () => {
    print(`  loaded ${lines.length} lines`);

    // if you want to whole file as one big string (with new line chars too),
    // join the lines back into one big string (with new lines inserted)
    all = lines.join("\n");
  });
}

function setup() {
  // createCanvas(500, 100)

  // can print everything to the console
  print(all);

  // simple HTML textarea debug window
  createDebugWindow();
  debug(all);

  // just so you don't think this is broken
  background(240);
  fill(0);
  textAlign(CENTER, CENTER);
  text("empty\ncanvas", width / 2, height / 2);
}
