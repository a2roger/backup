/*
 * streetview1
 *   Shows how to access streetview images with a querystring API.
 *
 *   NOTE:  you need an API key, use this page
 *          https://developers.google.com/maps/documentation/streetview/get-api-key  
 *
 */
 
// you can also paste an API key here (but not recommended)
String API_KEY;

void setup() {
  size(500, 500);
  
  // load API key from auth file
  // (if this fails, make sure you create the auth_google.json file in the
  // parent directory to the workshop repo, and that you have a valid Google
  // API key)
  JSONObject auth = loadJSONObject("../../../auth_google.json");
  API_KEY = auth.getString("API_KEY");

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
    
    println(url);

  return loadImage(url, "jpg");
}
