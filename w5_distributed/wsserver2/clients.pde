import java.util.concurrent.ConcurrentLinkedQueue;
import java.util.Map;
import java.util.Set;


// data structure to store the input state of each client
class InputState {

  void update(int f, int x, int y, boolean pressed) {
    if (f != frameNum) {
      pmouseX = mouseX;
      pmouseY = mouseY;
    }
    mouseX = x;
    mouseY = y;
    mousePressed = pressed;
    // to check for dead clients
    frameNum = f;
  }

  // nice output for debugging
  String toString() {
    return frameNum + ": " + mousePressed + 
      ",(" + pmouseX + "," + pmouseY + ")," +
      "(" + mouseX + "," + mouseY + ")";
  }

  // the clients state, the same as Processing
  int frameNum;
  int mouseX;
  int mouseY;
  int pmouseX;
  int pmouseY;
  boolean mousePressed;
}

// data structure to hold all clients and latest input state
HashMap<String, InputState> clients = new HashMap<String, InputState>();

// intermediate datastructure to transfer input messages 
// from socket thread to main thread
ConcurrentLinkedQueue<Message> q = new ConcurrentLinkedQueue<Message>();

// data structure to hold and parse each incoming socket message
class Message {

  Message(String msg) {
    String[] t = msg.split(",");
    id = t[0];
    e = t[1];
    x = int(t[2]);
    y = int(t[3]);
  }

  String toString() {
    return id + "," + e + "," + x + "," + y;
  }

  String id;
  String e;
  int x;
  int y;
}


void updateClientStates() {

  // update state of all clients
  while (!q.isEmpty()) {
    Message m = q.poll();

    if (!clients.containsKey(m.id)) {
      println("New Client: " + m.id);
      clients.put(m.id, new InputState());
    }

    if (m.e.equals("mm") || m.e.equals("md")) {
      clients.get(m.id).update(frameCount, m.x, m.y, m.e.equals("md"));
    }
  }
}


// callback when client sends message
// NOTE: this isn't on the drawing thread, so you can't draw here
void webSocketServerEvent(String msg) {
  Message m = new Message(msg);
  //println(m);
  
  // add this message to the threadsafe queue
  q.offer(m);
}
