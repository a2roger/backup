/*
 * streetview2
 *   Grabs images of random postal code locations.
 *
 *   NOTE:  you need an API key, use this page
 *          https://developers.google.com/maps/documentation/streetview/get-api-key  
 *
 */

// you can also paste an API key here (but not recommended)
let API_KEY = '';

let postalCodes;

function preload() {
  // load API key from auth file
  // (if this fails, make sure you create the auth_google.json file in the
  // parent directory to the workshop repo, and that you have a valid Google
  // API key)
  loadJSON("_private/auth.json", auth => {
    API_KEY = auth.API_KEY
  });

  // postal code csv is from http://www.geonames.org/
  postalCodes = loadTable("ca_postal_codes.csv", "header");
}

function setup() {
  createCanvas(500, 500)

  getRandomPlace();
}

function draw() {
  if (img != null) {
    image(img, 0, 0);

    textSize(60);
    textAlign(CENTER, CENTER);
    background(0);
    text(pcode, width / 2, height / 2);
  }
}

let img;
let pcode = "";

function getRandomPlace() {

  let n = postalCodes.getRowCount();

  let found = false;
  while (!found) {

    let i = int(random(0, n));

    let latitude = postalCodes.getRow(i).getFloat("Latitude");
    let longitude = postalCodes.getRow(i).getFloat("Longitude");

    let loc = latitude + "," + longitude;

    pcode = postalCodes.getRow(i).getString("Postal Code");

    print(pcode, loc);

    if (isStreetViewImage(loc)) {
      img = getStreetViewImage(loc, width, height, 90, 0, 0);
      found = true;
      print(" found");
    } else {
      print(" no image");
    }
  }
}

function keyPressed() {
  if (key == ' ') {
  }
}

function mousePressed() {
}

// location can be lat,long or address
function makeStreetViewURL(location, w, h, fov, head, pitch) {

  let url = "https://maps.googleapis.com/maps/api/streetview" +
    "?size=" + w + "x" + h +
    "&location=" + location +
    "&fov=" + fov + "&heading=" + head + "&pitch=" + pitch +
    "&key=" + API_KEY;

  print(url);

  return url
}

function isStreetViewImage(location) {

  let url = "https://maps.googleapis.com/maps/api/streetview/metadata" +
    "?location=" + location + 
    "&key=" + API_KEY;

  let response = loadJSON(url);
  println(response);

  let status = response.getString("status");
  print(status);

  return (status.compareTo("OK") == 0);
}







