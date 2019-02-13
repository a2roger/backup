/*
 * rss feed data demo
 *   Loads and displays a news feed from CBC
 * 
 */


void setup() {

  String url = "http://www.cbc.ca/cmlink/rss-sports-curling";
  println("Loading rss feed: " + url);
  XML xml = loadXML(url);
  println("  loaded");
  
  println(xml);
  
  XML[] items = xml.getChild("channel").getChildren("item");
  
  println(items.length + " items");
  
  for (XML x: items) {
    
    // best to check if element is there using 
    // x.hasAttribute("cbc:type") and  x.getString("cbc:type")
    // but we'll just go for it and hope for the best
    println(x.getChild("title").getContent());     
  }
}
