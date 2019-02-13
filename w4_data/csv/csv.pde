/*
 * csv
 *   Minimal sketch to load a csv into a `Table`,
 *   display some meta information, and iterate through the data.
 * 
 *   Based off of loadTable reference page: 
 *   https://processing.org/reference/loadTable_.html
 *
 */

Table table;

void setup() {

  // load in the csv data

  // local file (in data/" directory of this sketch)
  String fn = "ca_postal_codes.csv";
  // remember, always good to print out some information about the 
  // data you loaded to help diagnose problems
  println("Loading `" + fn + "'...");
  table = loadTable(fn, "header");
  println("  loaded " + table.getRowCount() + " rows in " +
    table.getColumnCount() + " columns");

  // print out the column names and types (good for diagnosing problems)
  for (String c : table.getColumnTitles()) {
    println(c, table.getColumnType(c));
  }
  
  // try sorting the data
  //table.sort("Longitude");

  // iterate through the rows
  for (int i = 0; i < table.getRowCount(); i++) {
    TableRow r = table.getRow(i);
    String s = r.getString("Place Name");
    println(i, s);
  }

}
