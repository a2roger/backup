import websockets.*;

WebsocketClient wsc;

void setup() {
  size(400, 400);

  // make sure server is already running on this port
  wsc = new WebsocketClient(this, "ws://localhost:3001");
  //wsc = new WebsocketClient(this, "ws://192.168.1.111:3001");  
}

void draw() {
  // nothing here
}


void mouseDragged() {
  // first create message to send to server
  wsc.sendMessage(mouseX + "," + mouseY);
  // then draw some local feedback
  fill(0);
  ellipse(mouseX, mouseY, 10, 10);
}


void keyPressed() {
}

// event callback when server sends message
// (note this is not on drawing thread)
void webSocketEvent(String msg) {
  println(msg);
}
