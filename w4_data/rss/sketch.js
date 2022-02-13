/*
 * rss feed data demo
 *   Loads and displays a news feed from CBC
 * 
 */

function setup() {

  // let url = 'http://www.cbc.ca/cmlink/rss-sports-curling';
  let url = 'data/rss-sports-curling.rss';

  print("Loading rss feed: " + url);

  let xml = loadXML(url, function () {
    print("  loaded");

    //println(xml);

    let items = xml.getChild("channel").getChildren("item");

    print(items.length + " items");

    for (let x of items) {

      // best to check if element is there using 
      // x.hasAttribute("cbc:type") and  x.getString("cbc:type")
      // but we'll just go for it and hope for the best
      print(x.getChild("title").getContent());
    }
  });
}
