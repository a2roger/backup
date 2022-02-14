/*
 * rss feed data demo
 *   Loads and displays a news feed from CBC
 * 
 */

function setup() {

  createDebugWindow();

  // local version for testing
  // let src = 'data/rss-sports-curling.rss';

  // load live rss feed
  let src = 'http://www.cbc.ca/cmlink/rss-sports-curling';
  // IMPORTANT! loading from remote files will cause "CORS" error 
  // until you allow it in your browser

  debug("Loading rss feed: " + src);

  let xml = loadXML(src, function () {
    debug("  loaded");

    //println(xml);

    let items = xml.getChild("channel").getChildren("item");

    debug(items.length + " items");

    for (let x of items) {

      // best to check if element is there using 
      // x.hasAttribute("cbc:type") and  x.getString("cbc:type")
      // but we'll just go for it and hope for the best
      debug(x.getChild("title").getContent());
    }
  });

  // just so you don't think this is broken
  background(240)
  fill(0)
  textAlign(CENTER, CENTER);  
  text('empty\ncanvas', width/2, height/2)
}
