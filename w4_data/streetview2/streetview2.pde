/*
 * streetview2
 *   Grabs images of random postal code locations.
 *
 *   NOTE:  you need an API key, use this page
 *          https://developers.google.com/maps/documentation/streetview/get-api-key  
 *
 */
import java.net.*;

// you can also paste an API key here (but not recommended)
String API_KEY;

Table postalCodes;

void setup() {
  size(500, 500);
  
  // load API key from auth file
  // (if this fails, make sure you create the auth_google.json file in the
  // parent directory to the workshop repo, and that you have a valid Google
  // API key)
  JSONObject auth = loadJSONObject("../../../auth_google.json");
  API_KEY = auth.getString("API_KEY");  

  // postal code csv is from http://www.geonames.org/
  postalCodes = loadTable("ca_postal_codes.csv", "header");

  //img = getStreetViewImage("50.9693,-114.0514", width, height, 90, 0, 0);
  //img = getStreetViewImage("Waterloo,ON", width, height, 90, 0, 0);

  getRandomPlace();


  // setup text style
  textSize(60);
  textAlign(CENTER, CENTER);
  background(0);
}


void draw() {
  if (img != null) {
    image(img, 0, 0);
    text(pcode, width/2, height/2);
  }
}

void keyPressed() {
 getRandomPlace(); 
}



PImage img;
String pcode = "";

void getRandomPlace() {

  int n = postalCodes.getRowCount();

  boolean found = false;
  while (!found) {

    int i = int(random(0, n));

    float latitude = postalCodes.getRow(i).getFloat("Latitude");
    float longitude = postalCodes.getRow(i).getFloat("Longitude");

    String loc = latitude + "," + longitude;

    pcode = postalCodes.getRow(i).getString("Postal Code");

    print(pcode, loc);

    if (isStreetViewImage(loc)) {
      img = getStreetViewImage(loc, width, height, 90, 0, 0);
      found = true;
      println(" found");
    } else {
      println(" no image");
    }
  }
}


// location can be lat,long or address
PImage getStreetViewImage(String location, int w, int h, int fov, int head, int pitch ) {
  //boolean sensor = false;

  String url = "https://maps.googleapis.com/maps/api/streetview" + 
    "?size=" + w + "x" + h + 
    "&location=" + location + 
    "&fov=" + fov + "&heading=" + head + "&pitch=" + pitch + 
    //"&sensor=" + sensor +
    "&key=" + API_KEY;

  return loadImage(url, "jpg");
}


boolean isStreetViewImage(String location) {

  String url = "https://maps.googleapis.com/maps/api/streetview/metadata" +
    "?location=" + location + 
    "&key=" + API_KEY;

  JSONObject response = loadJSONObject(url);
  println(response);

  String status = response.getString("status");
  println(status);

  return (status.compareTo("OK") == 0);
}
