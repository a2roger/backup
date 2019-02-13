/*
 * forecast - rss demo
 *   Loads and displays the current weather conditions for 
 *   Canadian cities. Press a key to get the weather for a new random city.
 * 
 */

String city;
String current;

// table of provinces
String[] provinces = {"ab", "bc", "mb", "nb", "nl", "nt", "ns", "nu", "on", "pe", "qc", "sk", "yt"};

void setup() {

  size(720, 480);

  // 82 is kitchener
  getWeather("on", 82);

  // setup text style
  textSize(40);
  textAlign(CENTER, CENTER);
  background(0);

  fill(0);
}


void draw() {
  background(255);

  text(city, width / 2, height / 2 - 30);
  text(current, width / 2, height / 2 + 30);
}

void keyPressed() {

  boolean success = false;
  while (!success) {
    int cityCode = int(random(1, 100)); // I have no idea how many are in each province
    String prov = provinces[int(random(0, provinces.length))];
    success = getWeather(prov, cityCode);
  }
}


// local weather forecast
boolean getWeather(String prov, int cityCode) {

  XML xml;
  String url = "https://weather.gc.ca/rss/city/" + prov + "-" + cityCode + "_e.xml";
  println(url);

  // try to get the RSS feed for the city, if not found return false
  try { 
    xml = loadXML(url);
    if (xml == null) {
      println("invalid city code " + cityCode);
      return false;
    }
  } 
  catch (Exception e) {
    println("invalid city code " + cityCode);
    return false;
  }

  // now process the XML from the feed
  println(url, xml);

  // get city name
  city = xml.getChild("title").getContent().split(" - ")[0].trim();
  //println(city);

  // find current forecast 
  // (I figured this out by looking at the raw XML in a web browser)
  XML[] entries = xml.getChildren("entry");

  for (XML x : entries) {
    String entryTitle = x.getChild("title").getContent();

    String[] t = entryTitle.split(":");
    if (t[0].startsWith("Current Conditions")) {
      //println(t[1]);
      current = t[1];
    }
  }

  return true;
}
