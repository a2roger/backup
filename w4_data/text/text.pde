/*
 * text data demo
 *   Loads text and prints it to the console. 
 */

void setup() {
 
  // you can also load from the web by giving a URL
  //String fn = "http://www.gutenberg.org/cache/epub/2489/pg2489.txt";
  // this file better tbe in the /data subdirectory
  String fn = "1342-0.txt";
  
  // useful to print some messages to the console to track down bugs and 
  // problems with data sourses
  println("Loading `" + fn + "'...");
  String[] lines = loadStrings(fn);
  println("  loaded " + lines.length + " lines");  
  
  // loadStrings returns an array containing each line of the text file
  // if you want to whole file as one big string (with new line chars too),
  // join the lines back into one big string (with new lines inserted)
  String all = String.join("\n", lines);
  // for now, we just print everything to the console
  println(all);

}
