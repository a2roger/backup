public static final String[] NOTE_NAMES = {"C", "C#", "D", "D#", "E", "F", "F#", "G", "G#", "A", "A#", "B"};

class MidiLoader {
  Sequence sequence;

  // Midi Vars
  int largestTrack = 0;
  int midi_index = 0;
  int midi_trigger = 0;
  long prev_tick = 0;
  Track mainTrack;

  // The trigger is an integer number in milliseconds so we can schedule new events in the draw loop
  int trigger;

  MidiLoader(String file) {
    // Init Midi
    try
    {
      sequence = MidiSystem.getSequence(new File(file));
    }
    catch(Exception e)
    {
      print("FILE NOT FOUND!!");
      exit();
    }

    // Init Midi
    largestTrack = 0;
    int temp = -1; 
    int index = 0;
    for (Track track : sequence.getTracks()) {
      if (temp < track.size()) {
        temp = track.size();
        largestTrack = index;
      }
      System.out.println("Track " + index + ": size = " + track.size());
      System.out.println();

      index++;
    }

    // Assign main track
    mainTrack = sequence.getTracks()[largestTrack];
    prev_tick = mainTrack.get(0).getTick();

    // Create trigger for midi
    midi_trigger = millis();
  }
  
  void draw() {
    
   if (millis() > midi_trigger) {
    MidiEvent event = mainTrack.get(midi_index);
    println("@" + event.getTick() + " ");
    
    MidiMessage message = event.getMessage();
    if (message instanceof ShortMessage) {
      ShortMessage sm = (ShortMessage) message;
      println("Channel: " + sm.getChannel() + " ");
      
      if (sm.getCommand() == ShortMessage.NOTE_ON) {
        int key = sm.getData1();
        int octave = (key / 12)-1;
        int note = key % 12;
        String noteName = NOTE_NAMES[note];
        int velocity = sm.getData2();
        println("Note on, " + noteName + octave + " key=" + key + " velocity: " + velocity + " ticks=" + mainTrack.get(midi_index).getTick());
        
        // Set Duraction;
        prev_tick = mainTrack.get(midi_index).getTick();
        long next_tick = mainTrack.get(midi_index+1).getTick();
        midi_trigger = millis() + 200;//(int) map(next_tick - prev_tick, 0, 200, 100, 1000);//round(map(duration, 0, 3, 0, 1000));
        midi_index++;
        
        // Callback
        NoteCallback(key, velocity);
        
    } else {
        System.out.println("Command:" + sm.getCommand());
      }
    } else {
      System.out.println("Other message: " + message.getClass());
    }
    
    midi_index++;
    
  } 
  }
}