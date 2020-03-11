import websockets.*;

WebsocketClient wsc;

String id = "1"; //str(int(random(10000, 99999)));

void setup() {
  size(400, 400);

  wsc = new WebsocketClient(this, "ws://localhost:3001");
  //wsc = new WebsocketClient(this, "ws://192.168.1.111:3001");
}

void draw() {
  // nothing here
}

// my custom general message builder
void sendMessage(String e, Object... data) {
  StringBuilder s = new StringBuilder();
  for (Object d : data) {
    s.append("," + d);
  }
  // not it send the client "id", just a number I assign
  wsc.sendMessage(id + "," + e + s);
}

void mouseMoved() {
  sendMessage("mm", mouseX, mouseY);
}

void mouseDragged() {
  sendMessage("md", mouseX, mouseY);
}

void mousePressed() {
  sendMessage("mp", mouseX, mouseY);
}

void mouseReleased() {
  sendMessage("mr", mouseX, mouseY);
}

void keyPressed() {
  // hack to change between multiple client ids for testing
  if (key > '0' && key < '9') {
    id = str(key);
  }
}

void webSocketEvent(String msg) {
  println(msg);
}
