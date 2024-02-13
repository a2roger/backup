/*
 * streetview2
 *   Grabs images of random postal code locations.
 *
 *   NOTE:  you need an API key, use this page
 *          https://developers.google.com/maps/documentation/streetview/get-api-key
 *
 */

// you can also paste an API key here (but not recommended)
let API_KEY = "";

let postalCodes;

function preload() {
  // load API key from auth file
  // (if this fails, make sure you create the auth_google.json file in the
  // parent directory to the workshop repo, and that you have a valid Google
  // API key)
  loadJSON("_private/auth.json", (auth) => {
    API_KEY = auth.API_KEY;
  });

  // postal code csv is from http://www.geonames.org/
  postalCodes = loadTable("data/ca_postal_codes.csv", "header");
}

function setup() {
  // full browser canvas
  createCanvas();
  resizeCanvas(windowWidth, windowHeight);

  print("press space for a new location");

  // start the display
  getRandomPlace();
}

// current image and postal code to display
let streetViewImage;
let pcode = "";

function draw() {
  background(0);

  if (streetViewImage) {
    push();
    imageMode(CENTER);
    image(streetViewImage, width / 2, height / 2);
    // display postal code on top
    textSize(60);
    textAlign(CENTER, CENTER);
    fill(255);
    text(pcode, width / 2, height / 2);
    pop();
  }
}

function getRandomPlace() {
  // get a random postal code
  let n = postalCodes.getRowCount();
  let i = int(random(0, n));
  pcode = postalCodes.getRow(i).getString("Postal Code");

  // create the street view lat and long string
  let latitude = postalCodes.getRow(i).getNum("Latitude");
  let longitude = postalCodes.getRow(i).getNum("Longitude");
  let loc = latitude + "," + longitude;

  print(`getting street view for ${pcode} at ${loc}`);

  // get the image and display it
  let url = makeStreetViewURL(loc, width, height, 90, 0, 0);
  streetViewImage = loadImage(url, (i) => {
    print(`loaded ${url}`);
  });
}

function keyPressed() {
  if (key == " ") {
    getRandomPlace();
  }
}

// location can be lat,long or address
function makeStreetViewURL(location, w, h, fov, head, pitch) {
  let url =
    "https://maps.googleapis.com/maps/api/streetview" +
    `?size=${w}x${h}` +
    `&location=${location}` +
    `&fov=${fov}` +
    `&heading=${head}` +
    `&pitch=${pitch}` +
    `&key=${API_KEY}`;

  // print(url);
  return url;
}

// function isStreetViewImage(location) {

//   let url = "https://maps.googleapis.com/maps/api/streetview/metadata" +
//     "?location=" + location +
//     "&key=" + API_KEY;

//   let response = loadJSON(url);
//   println(response);

//   let status = response.getString("status");
//   print(status);

//   return (status.compareTo("OK") == 0);
// }
