/*
 * temperature - demos tabular data processing 
 *   loads and displays historical csv data from UWaterloo 
 *   weather station: http://weather.uwaterloo.ca/data.html
 *
 */

// based off of loadTable reference page:
// https://processing.org/reference/loadTable_.html

Table table;

void setup() {
  
  // 15 minutes per day is 96 readings (x)
  // 365 days (y)
  size(96, 365);

  // load in the csv data

  // You can also load from the web by giving a URL. But remember
  // each file is ~12MB, and it will download everytime you
  // run a sketch if you access by URL.
  // Note: 2015 and prior URLs are formated "http://weather.uwaterloo.ca/download/2014_weather_station_data.csv"
  //String fn = "http://weather.uwaterloo.ca/download/Hobo_15minutedata_2016.csv";

  // local file (in data/" directory of this sketch)
  String fn = "Hobo_15minutedata_2018.csv";
  println("Loading `" + fn + "'...");
  table = loadTable(fn, "header");
  println("  loaded " + table.getRowCount() + " rows in " +
    table.getColumnCount() + " columns");

  // print out the column names and types
  for (String c : table.getColumnTitles()) {
    println(c, table.getColumnType(c));
  }
  
  // maek the viz
  createTemperatureViz();
}



void createTemperatureViz() {
  background(0);

  int x = 0;
  int y = 0;
  int day = 0;

  // switch colour mode to adjust brightness easily
  colorMode(HSB, 360, 100, 100, 100);
  for (TableRow row : table.rows()) {

    // new row of points if new day
    int d = int(row.getFloat("day"));
    if (d != day) {
      x = 0;
      y++;
      day = d;
    }

    // get temperature at that moment
    float t = row.getFloat("Temperature");

    // change hue from red to blue if negative temperature
    float h = 0;
    if (t < 0) {
      h = 230;
    }
    // map the temperature to brightness
    float b = map(abs(t), 0, 35, 0, 100);

    // render the pixel 
    stroke(h, 90, b);
    point(x, y);
    x++;
  }
}
