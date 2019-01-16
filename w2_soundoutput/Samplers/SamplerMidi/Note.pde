class Note {
  float x, y;
  int note, vel;
  public Note(float _x) {
    x = _x;
  }

  public void DeepCopy(Note n) 
  {
    note = n.note;
    vel = n.vel;
  }
  public void set(int _note, int _vel) {
    note = _note;
    vel = _vel;
  }

  void draw() {
    float hue = map(note, 0, 128, 120, 189);
    fill(hue, 100, 100);
    
    y = (note % 12) * height/12;
    ellipse(x, y, hue/10, hue/5);
  }
}
