

function preload() {
  // local file (in data/" directory of this sketch)
  let fn = "data/ca_postal_codes.csv";

// remember, always good to print out some information about the 
  // data you loaded to help diagnose problems
  print(`Loading '${fn}'...`);
  table = loadTable(fn, 'csv', 'header', function() {
    print(`  loaded ${table.getRowCount()} rows in ${table.getColumnCount()} columns`);
  });
}

function setup() {
  
  // simple HTML textarea debug window
  createDebugWindow();

  // print out the column names and types (good for diagnosing problems)
  for (c of table.columns) {
    debug(`${c}: ${typeof(c)}`);
  }
  
  // try sorting the data
  //table.sort("Longitude");

  // iterate through the rows
  for (let i = 0; i < table.getRowCount(); i++) {
    let r = table.getRow(i);
    let s = r.getString("Place Name");
    debug(`${i} ${s}`);
  }  

  // just so you don't think this is broken
  background(240)
  fill(0)
  textAlign(CENTER, CENTER);  
  text('empty\ncanvas', width/2, height/2)
 }





