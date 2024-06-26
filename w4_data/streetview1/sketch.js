/*
 * streetview1
 *   Shows how to access streetview images with a querystring API.
 *
 *   NOTE:  you need an API key, use this page
 *          https://developers.google.com/maps/documentation/streetview/get-api-key
 */

// you can also paste an API key here (but not recommended)
let API_KEY = "";

function preload() {
  // load API key from auth file
  loadJSON("_private/auth.json", (auth) => {
    API_KEY = auth.API_KEY;
  });
}

function setup() {
  createCanvas(500, 500);
}

function keyPressed() {
  if (key == " ") {
    // get streetview image here
    let loc;
    // loc = "48.8742,2.2948";
    loc = "Sacville,NB";

    let url = makeStreetViewURL(loc, width, height, 90, 170, 10);

    // get the image and display it
    loadImage(url, (img) => {
      image(img, 0, 0);
    });
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

  print(url);

  return url;
}
