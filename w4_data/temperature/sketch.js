/*
 * temperature - demos tabular data processing 
 *   loads and displays historical csv data from UWaterloo 
 *   weather station: http://weather.uwaterloo.ca/data.html
 *
 */

let table;

function preload() {
   // load in the csv data

  // You can also load from the web by giving a URL. But remember
  // each file is ~12MB, and it will download everytime you
  // run a sketch if you access by URL.
  // Note: 2015 and prior URLs are formatted "http://weather.uwaterloo.ca/download/2014_weather_station_data.csv"
  //       2020 data seems to have changed data format
  // let src = "http://weather.uwaterloo.ca/download/Hobo_15minutedata_2016.csv";
  let src = "data/Hobo_15minutedata_2018.csv";

  print(`Loading '${src}'...`);
  table = loadTable(src, "header");
  print(`  loaded ${table.getRowCount()} rows ` +
            `in ${table.getColumnCount()} columns`);
}

function setup() {
 
  // scale factor
  let s = 5

   // 15 minutes per day is 96 readings (x)
  // 365 days (y)
  createCanvas(96 * s, 365 * s);

  scale(s, s)

  // print out the column names and types
  for (c in table.columns) {
    print(c);
  }
  
  // make the viz
  createTemperatureViz();
 }

 function createTemperatureViz() {
  background(0);

  let x = 0;
  let y = 0;
  let day = 0;

  // switch colour mode to adjust brightness easily
  colorMode(HSB, 360, 100, 100, 100);
  for (row of table.rows) {

    // new row of points if new day
    let d = int(row.getNum("day"));
    if (d != day) {
      x = 0;
      y++;
      day = d;
    }

    // get temperature at that moment
    let t = row.getNum("Temperature");

    // change hue from red to blue if negative temperature
    let h = 0;
    if (t < 0) {
      h = 230;
    }
    // map the temperature to brightness
    let b = map(abs(t), 0, 35, 0, 100);

    // render the pixel 
    stroke(h, 90, b);
    point(x, y);
    x++;
  }
}



