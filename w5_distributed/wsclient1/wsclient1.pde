import websockets.*;

WebsocketClient wsc;

void setup() {
  size(400, 400);

  //wsc = new WebsocketClient(this, "ws://192.168.1.111:3001");
  wsc = new WebsocketClient(this, "ws://localhost:3001");
}

void draw() {
  // nothing here
}


void mouseDragged() {
  wsc.sendMessage(mouseX + "," + mouseY);
  fill(0);
  ellipse(mouseX, mouseY, 10, 10);
}


void keyPressed() {
}

// received message from server
void webSocketEvent(String msg) {
  println(msg);
}
