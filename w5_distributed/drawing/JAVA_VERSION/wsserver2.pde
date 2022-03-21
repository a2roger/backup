import websockets.*;

WebsocketServer ws;

void setup() {
  size(400, 400);
  ws = new WebsocketServer(this, 3001, "");

  // create the visualization PGraphics
  PGraphics d = createGraphics(width, height);
  d.beginDraw();
  d.background(0);
  d.endDraw();
  vizGraphics = d;
}

// the drawing created by the visualization
PGraphics vizGraphics;

boolean showCursors = true;

// choose different visualization here
Viz viz = new DrawingViz();

void draw() {
  background(0);

  updateClientStates();
  
  // draw the selected visualization into a PGraphics
  // then display it
  viz.draw(vizGraphics);
  image(vizGraphics, 0, 0);

  // render information about the clients
  fill(255, 255, 0);
  for (String c : clients.keySet()) {

    // examine what the client is doing (position, mouseDown, etc.)
    InputState i = clients.get(c);

    if (showCursors) {
      fill(200);
      textSize(12);
      text(c, i.mouseX + 10, i.mouseY + 10);
      rectMode(CENTER);
      stroke(200);
      noFill();
      rect(i.mouseX, i.mouseY, 8, 8);
    }
  }
}

void keyPressed() {

  if (key == ' ') {
    showCursors = !showCursors;
  } else {
    ws.sendMessage("Hi from server.");
  }
}
