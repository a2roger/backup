/*
 * streetview1
 *   Shows how to access streetview images with a querystring API.
 *   
 *
 */
 
 // get an API key on this page:
// https://developers.google.com/maps/documentation/streetview/intro
String API_KEY = "";

void setup() {
  size(500, 500);

  PImage img;

  String loc;

  //loc = "48.8742,2.2948";
  loc = "Kitchener,ON";

  img = getStreetViewImage(loc, width, height, 90, 170, 10);
  image(img, 0, 0);
}


// location can be lat,long or address
PImage getStreetViewImage(String location, int w, int h, int fov, int head, int pitch ) {

  String url = "https://maps.googleapis.com/maps/api/streetview" + 
    "?size=" + w + "x" + h + 
    "&location=" + location + 
    "&fov=" + fov + "&heading=" + head + "&pitch=" + pitch + 
    "&key=" + API_KEY;

  return loadImage(url, "jpg");
}
