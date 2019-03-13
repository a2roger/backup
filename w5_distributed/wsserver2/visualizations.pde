
// different visualizations

// very simple base class
abstract class Viz {
  abstract void draw(PGraphics d);
}

// DrawingViz: each client draws a line
class DrawingViz extends Viz {

  void draw(PGraphics d) {

    for (String c : clients.keySet()) {

      InputState i = clients.get(c);

      if (i.mousePressed) {
        d.beginDraw();
        d.stroke(255);
        d.strokeWeight(10);
        d.line(i.mouseX, i.mouseY, i.pmouseX, i.pmouseY);
        d.endDraw();
      }
    }
  }
}


// CompetitiveDrawingViz: some clients erase, some draw
class CompetitiveDrawingViz extends Viz {

  int lastSwitchTime = 0;
  String erasingClient = "";

  void draw(PGraphics d) {

    // choose a different client to erase every 10s
    if (clients.size() > 1) {  
      if (erasingClient.equals("") || 
        lastSwitchTime + 10000 < millis()) {
        // get list of all clients
        Set<String> keys = clients.keySet();
        String[] a = keys.toArray(new String[keys.size()]);
        // choose one client from the list
        erasingClient = a[int(random(a.length))];
        println(erasingClient + " will erase");
        // reset the timer to pick a new one in 10s
        lastSwitchTime = millis();
      }
    }

    // draw all the client shapes for this frame
    int hue = 0;
    d.colorMode(HSB, 360, 100, 100, 100);

    for (String c : clients.keySet()) {

      InputState i = clients.get(c);

      if (i.mousePressed) {
        d.beginDraw();
        d.noStroke();
        if (c == erasingClient) {
          d.fill(0);
          d.ellipse(i.mouseX, i.mouseY, 50, 50);
        } else {
          d.stroke(hue, 100, 100);
          d.strokeWeight(2);
          d.line(i.mouseX, i.mouseY, i.pmouseX, i.pmouseY);
        }
        d.endDraw();
      }
      hue += 360/10;
    }
  }
}


// PolygonViz: joins all clients into a polygon
class PolygonViz extends Viz {

  void draw(PGraphics d) {

    d.beginDraw();
    d.background(0, 255);
    d.stroke(255, 255);
    d.noFill();
    d.beginShape();
    for (String c : clients.keySet()) {

      InputState i = clients.get(c);

      d.vertex(i.mouseX, i.mouseY);
    }

    d.endShape(CLOSE);
    d.endDraw();
  }
}
