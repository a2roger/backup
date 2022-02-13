/*
 * forecast - rss demo
 *   Loads and displays the current weather conditions for 
 *   Canadian cities. Press a key to get the weather for a new random city.
 * 
 */

let city;
let current;

// parameters
let p = {
  boolean: true,
  numeric: 50,
  numericMin: 0,
  numericMax: 100,
  numericStep: 1,
}

function preload() {
}

function setup() {
  createCanvas(500, 500)
  
  // add params to a GUI
  // createParamGui(p, paramChanged);

  getWeather("on", 82);

  background(0);
 }

 // local weather forecast
function getWeather(prov, cityCode) {
  // let url = "https://weather.gc.ca/rss/city/" + prov + "-" + cityCode + "_e.xml";
  // print(url);
  let url = "data/on-82_e.xml"

// try to get the RSS feed for the city, if not found return false
// try { 
//   xml = loadXML(url);
//   if (xml == null) {
//     println("invalid city code " + cityCode);
//     return false;
//   }
// } 
// catch (Exception e) {
//   println("invalid city code " + cityCode);
//   return false;
// }  
  
  let xml = loadXML(url, 
  function() { 
    print('success') 
    // now process the XML from the feed
    // print(url, xml.listChildren());

    // get city name
    city = xml.getChild("title").getContent().split(" - ")[0].trim();
    print(`'${city}'`);

    // find current forecast 
    // (I figured this out by looking at the raw XML in a web browser)
    let entries = xml.getChildren("entry");

    for (let x of entries) {
      let entryTitle = x.getChild("title").getContent();

      let t = entryTitle.split(":");
      if (t[0].startsWith("Current Conditions")) {
        print(t[1]);
        current = t[1];
      }  
    }
    return true;
  }, 
  function(e) { print(`error '${e}'`); return false;}
  );
}

function draw() {
  background(255);

  // setup text style
  fill(0);
  textSize(40);
  textAlign(CENTER, CENTER);

  text(city, width / 2, height / 2 - 30);
  text(current, width / 2, height / 2 + 30);
}

function keyPressed() {
  let success = false;
  while (!success) {
    let cityCode = int(random(1, 100)); // I have no idea how many are in each province
    let prov = provinces[int(random(0, provinces.length))];
    success = getWeather(prov, cityCode);
  }
}

function mousePressed() {
}

function windowResized() {
}

// global callback from the settings GUI
function paramChanged(name) {
}



