/*
 * guttenberg - demos text processing
 *   Loads text from Project Gutenberg, processes it into 
 *   individual words, and plays the words in sequence as an animation. 
 */

String[] words;
int index = 0;

void setup() {
  size(720, 480);
  
  // you can also load from the web by giving a URL
  //String fn = "http://www.gutenberg.org/cache/epub/2489/pg2489.txt";
  //String start = "*END THE SMALL PRINT!";
  
  String fn = "1342-0.txt";
  
  // I looked at the file, and found this frontmatter text comes
  // right before the actual book text. It seems to be different for 
  // each file (or at least different types of books)
  String start = "Produced by Anonymous Volunteers";

  println("Loading `" + fn + "'...");
  String[] lines = loadStrings(fn);
  println("  loaded " + lines.length + " lines");

  // strip out guttenberg frontmatter and endmatter
  StringBuilder s = new StringBuilder();
  boolean frontmatter = true;
  for (String l: lines) {
    if (frontmatter && l.contains(start)) {
      frontmatter = false;
    } else if (!frontmatter) {
      s.append(l + " ");
    }
  }
  String book = s.toString();

  println("  found " + book.length() + " characters in book");

  // split on whitespace to get individual words
  words = splitTokens(book, " ");
  println("  found " + words.length + " words in book");
  
  // setup text style
  textSize(60);
  textAlign(CENTER, CENTER);
  background(0);
}


void draw() {
  //background(0);
  float alpha = adjustY(0, 50); // 10 looks nice
  fill(0, alpha);
  rect(0, 0, width, height);
   
  fill(255);
  text(words[index], width/2, height/2);
  
  int update = int(adjustX(1, 60)); // ~16 looks nice
  
  if (frameCount % update == 0) {
    index++;
  }
}


// helper functions to adjust values with mouse

float adjustX(float low, float high) {
   float v = map(mouseX, 0, width - 1, low, high); 
   println("adjustX: ", v);
   return v;
}

float adjustY(float low, float high) {
   float v = map(mouseY, 0, height - 1, low, high); 
   println("adjustY: ", v);
   return v;
}
