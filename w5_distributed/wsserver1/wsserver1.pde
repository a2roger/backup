import websockets.*;

// needed for reliabile transfering data from message 
// thread to drawing thread
import java.util.concurrent.ConcurrentLinkedQueue;

WebsocketServer ws;

void setup() {
  size(400, 400);

  // start server
  ws = new WebsocketServer(this, 3001, "");

  background(0);
}

void draw() {

  // process the queue of messages
  while (!q.isEmpty()) {
    // pull off message from tail, and paint it as ellipse
    Message m = q.poll();
    noStroke();
    fill(255);
    ellipse(m.x, m.y, 10, 10);
  }
}

void keyPressed() {
  ws.sendMessage("hi from server");
}

// data structure to hold and parse each incoming socket message
class Message {

  Message(String msg) {
    String[] t = msg.split(",");
    x = int(t[0]);
    y = int(t[1]);
  }

  String toString() {
    return x + "," + y;
  }

  int x;
  int y;
}

// special threadsafe queue to transfer input messages 
// from socket thread to main thread
ConcurrentLinkedQueue<Message> q = new ConcurrentLinkedQueue<Message>();

// callback when client sends message
// NOTE: this isn't on the drawing thread, so you can't draw here
void webSocketServerEvent(String msg) {

  Message m = new Message(msg);
  println(m);
  
  // drawing here may not work because of thread boundaries
  //noStroke();
  //fill(255);
  //ellipse(m.x, m.y, 10, 10);

  // add this message to the threadsafe queue
  q.offer(m);
}
