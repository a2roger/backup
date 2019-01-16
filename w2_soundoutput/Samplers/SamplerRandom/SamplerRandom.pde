import processing.sound.*;

SoundFile[] file;

// Number of samples 
int numsounds = 5;

// An array of octaves, 1 is normal and each octave is half or twice the original. 
float[] octave = {0.25, 0.5, 1.0, 2.0, 4.0};

// playSound array defines what will be triggered
int[] playSound = {1,1,1,1,1};

// Trigger keeps track of time. 
int trigger;

void setup(){
  size(640, 360);
  colorMode(HSB, 360, 100, 100);
  background(255);
  
  // Create an array of empty soundfiles
  file = new SoundFile[numsounds];
  
  // Load 5 soundfiles from a folder in a for loop. By naming the files 1., 2., 3., n.aif it is easy to iterate
  // through the folder and load all files in one line of code.
  for (int i = 0; i < numsounds; i++){
    file[i] = new SoundFile(this, (i+1) + ".aif");
  }
  
  // Create a trigger which will be the basis for our random sequencer. 
  trigger = millis(); 
}

void draw(){
  
  // If the determined trigger moment in time matches up with the computer clock events get triggered.
  if (millis() > trigger){
    // Redraw the background every time to erase old rects
    background(0);
    
    // By iterating through the playSound array we check for 1 or 0, 1 plays a sound and draws a rect,
    // for 0 nothing happens.
    
    for (int i = 0; i < numsounds; i++){      
      // Check which indexes are 1 and 0.
      if (playSound[i] == 1){
          float rate;
          fill(260 + map(i, 0, numsounds, 0, 30),100, 100);
          noStroke();
          // Draw the rect in the positions we defined earlier in posx
          rect(i * width/numsounds, 50, 128, 260);
          // Choose a random index of the octave array
          rate = octave[int(random(0,5))];
          // Play the soundfile from the array with the respective rate and loop set to false
          file[i].play(rate, 1.0);
      }
      
      // Renew the indexes of playSound so that at the next event the order is different and randomized.
      playSound[i] = random(1) > 0.5 ? 1 : 0;
    }
    
    // creates an offset between .2 and 1 second
    trigger = millis() + int(random(200,1000));
  }
}