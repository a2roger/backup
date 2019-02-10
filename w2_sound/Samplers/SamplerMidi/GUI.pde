/* 
 * Simple GUI for parameter adjustment
 */


import controlP5.*;
import java.util.Calendar;


class Gui {

  ControlP5 controlP5;

  ControlGroup ctrl;
  boolean showGUI = false;

  Gui(processing.core.PApplet sketch) {

    color activeColor = color(0, 130, 164);
    controlP5 = new ControlP5(sketch);
    //controlP5.setAutoDraw(false);
    controlP5.setColorActive(activeColor);
    controlP5.setColorBackground(color(170));
    controlP5.setColorForeground(color(50));
    controlP5.setColorCaptionLabel(color(50));
    controlP5.setColorValueLabel(color(255));

    ctrl = controlP5.addGroup("menu", left, 15, 35);
    ctrl.setColorLabel(color(255));

    // position of controls relative to menu toggle
    lastLine = 10;
    ctrl.close();
  }

  int lastLine;

  int left = 5;
  int lineHeight = 15;
  int padding = 5;

  void newLine() {
    lastLine += lineHeight + padding;
  }

  void addSpace() {
    lastLine += lineHeight/2 + padding;
  }

  void addSlider(String variableName, float minVal, float maxVal) {
    Slider s = controlP5.addSlider(variableName, minVal, maxVal, left, lastLine, 300, lineHeight);

    s.setGroup(ctrl);
    //s.getCaptionLabel().toUpperCase(true);
    s.getCaptionLabel().getStyle().padding(4, 3, 3, 3);
    s.getCaptionLabel().getStyle().marginTop = -4;
    s.getCaptionLabel().getStyle().marginLeft = 0;
    s.getCaptionLabel().getStyle().marginRight = -14;
    s.getCaptionLabel().setColorBackground(0x99ffffff);

    newLine();
  }

  void draw() {
    controlP5.show();
    controlP5.draw();
  }


  void keyPressed() {

    if (key=='m' || key=='M') {
      showGUI = controlP5.getGroup("menu").isOpen();
      showGUI = !showGUI;
    }
    if (showGUI) { 
      controlP5.getGroup("menu").open();
      controlP5.getGroup("menu").show();
    } else {
      controlP5.getGroup("menu").close();
      if (key == 'M') 
        controlP5.getGroup("menu").hide();
    }
    
    // allow saving the frame too
    if (key=='s' || key=='S') {
      String t = String.format("%1$ty%1$tm%1$td_%1$tH%1$tM%1$tS", Calendar.getInstance()); 
      String fn = t + ".png";
      println("saving frame as '" + fn + "'");
      saveFrame(fn);
    }
    
  }
}