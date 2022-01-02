# Sound Workshop

We'll  explore different approaches and techniques for using sound in generative art.


## Goals

- Learn different ways that sounds can be played, e.g., via sampling, synthesis using oscillators
- Learn different ways that sound can be used to drive visualizations, e.g., via amplitude tracking, frequency analysis
- Experiment with autonomous agents to generate emergent sounds

## Setup

You'll need to include the p5.sound library in the `index.html` file that runs your script. The workshop demos load it as a local resource:

```html
<script src="libraries/p5.sound.min.js"></script> 
```

But you can also load it as a remote resource using CDN:
```html
<script src="https://cdnjs.cloudflare.com/ajax/libs/p5.js/1.4.0/addons/p5.sound.min.js"></script>
```

## Resources

### p5.js Sound Resources and Tutorials

- [p5.sound library reference](https://p5js.org/reference/#/libraries/p5.sound)
- [Daniel Shiffman's p5.js Sound Tutorials](https://www.youtube.com/playlist?list=PLRqwX-V7Uu6aFcVjlDAkkGIixw70s7jpW)

### Media Assets

- [**Freesound**](https://freesound.org/): "Freesound aims to create a huge collaborative database of audio snippets, samples, recordings, bleeps, ... released under Creative Commons licenses that allow their reuse."
- [**Free Music Archive**](https://freemusicarchive.org/): "Free Music Archive is known for free to download music licensed under Creative Commons."
<!-- - [ClassicalArchives](https://www.classicalarchives.com/midi.html) -->

### Tools

- [**Friture**](http://friture.org/download.html): a tool for audio spectrum analysis


# Introduction

How does sound as a medium differ from the visual? What makes it unique? 

Sound is intrinsically physical and temporal. Unlike light waves, sound waves need a physical material to propagate through, as well as an energy source (generator). When building compositions, we need to consider how these sound waves are temporally spaced, the shape of the wave, and how they change over time. There are other properties of course, such as tone, timbre, richness, tempo, and rhythm, that also need to be considered; but the entire domain of sound can be compacted into dimensions of time, shape, and change.

## The sound "canvas"

The human ear has a hearing range that falls between roughly 20Hz to 20kHz. For music, we think of as "notes" that fall into the 60Hz to 6400Hz range, where middle "A" is 440Hz. 

![https://www.audioreputation.com/audio-frequency-spectrum-explained/](img/Audio-Frequency-Spectrum-Explained.jpg "https://www.audioreputation.com/audio-frequency-spectrum-explained/") 

Another way to visualize the sound spectrum is through analysis. The image above shows how audio changes over time (x-axis) and over the frequency range (y-axis). Colour indicates volume (amplitude). 

![https://music.stackexchange.com/questions/10472/sound-spectrum-to-notes-software](img/spectrum.jpg "https://music.stackexchange.com/questions/10472/sound-spectrum-to-notes-software")


## Generative Sound in Generative Art

Sound, by itself, can be used as generative art. Philippe Pasquier and Arne Eigenfeldt explore this in their research into [Metacreation](http://metacreation.net/). 

In digital artwork, sound can function in three primary ways:


1. **Augmentation**: use sound to embellish or extend a visual artwork.
1. **Analysis:** generate an artwork by analyzing properties of sound.
2. **Synthesis:** use additive or subtractive synthesis to generate sound art.
<!-- 3. **Sampling:** using pre-recorded audio and manipulation techniques (e.g. effects) to generate sound are. 
4. **Monitoring:** use external devices (e.g. microphones) to record or monitor the environment. 
5. **Input generation:** seed values as a source of pseudo-randomness.  -->

In this workshop we demonstrate techniques for each of these.

# Augmentation

Perhaps the simplest way to use sound is to extend or enhance a visual artwork. 

## Sketch: **`gridfliptick`**

Extends an animated version of the `gridflip` demo from the previous workshop with added sound effects. 

### Loading Sound

Like images, sounds are loaded "asynchronously" which means the variable you use for the created sound may not be ready to be used right away. The easiest way to handle this is to load sound files in `preload`:

```js
// my sound file
let tick;

function preload() {
  tick = loadSound("data/254316__jagadamba__clock-tick.wav")
}
```

Preload is called before setup and it guarantees that `tick` will be loaded with the wav file and ready to use before setup, draw, mousePressed, etc. are run.

### Playing Sound

Playing sound is slightly more complicated on modern browsers. They all have restrictions like Chrome's [autoplay policy](https://developer.chrome.com/blog/autoplay/#webaudio) that prevents web pages from playing sounds without some user interaction like clicking on typing anywhere on the page first.  There used to be [some ways to hack around this](https://olafwempe.com/how-to-enable-audio-and-video-autoplay-with-sound-in-chrome-and-other-browsers-in-2019/), but things have been tightened up.

> **If you don't hear any sound, just click somewhere on the webpage and the sound should start.** You'll see warnings in the console if your sound is being ignored due to a browser policy. 


### Adjusting Playback

A [sound file has many more methods](https://p5js.org/reference/#/p5.SoundFile) than `play()`. In this demo, we adjust the volume since the wav file I used it really loud. I do this in `setup()` since:

```js
// turn down the sound
tick.setVolume(0.1);
```

### Exercise: Make a Stereo Tick

You can change "where" the sound plays in the left or right stereo channel using the [`pan()` method](https://p5js.org/reference/#/p5.SoundFile/pan). A value of -1 means play in the left channel, 1 means play in the right channel, and anything in between is a mix of both channels (i.e. the default value of 0 plays in both channels equally).

Let's pan the tick sound to match the horizontal canvas position of the Agent that's flipping. Add this code to `Agent.update()` just before the `tick.play()` line:

```js
// map agent x canvas position to a [-1, 1] stereo pan
let p = map(this.x, 0, width, -1, 1)
tick.pan(p)
```
> **Note:** You may need to listen with stereo headphones to really hear the effect. 


### Explore: Add More Sounds and/or Variation

* You could vary the volume of the tick based on Agent position or some pseudo random choice.
* You could experiment with the [rate() method](https://p5js.org/reference/#/p5.SoundFile/rate) to play the tick more slowly (or even backwards) depending on where the Agent is or some pseudo random choice.
* You could play a different sound depending on the flip direction. 
* You could choose to play one of a few different sounds at each flip. 
* Every agent could have its own sound, or maybe there are N type of agents that all share the same sound. 
  
For the additional sounds, could download a new sound on [**Freesound**](https://freesound.org/), create another variation of the tick wav using audio processing software, or record your own sound using your mic.


# Analysis

Two basic analysis techniques are to calculate the amplitude of a sound at a moment in time, or use a fast Fourier transform (FFT) to examine different frequencies of sound at a moment in time. 

> **Awesome Resource:** You need to check out this [The Pudding](https://pudding.cool/) interactive data visualization essay ["Let's Learn about Waveforms"](https://pudding.cool/2018/02/waveforms/). Not only is it an excellent technical explanation of sound that's highly relevant to this workshop, but the design of this "essay" (and many others on that site) is incredible. 

## amplitude

This sketch demonstrates how to analyze amplitude information from audio files. It visualizes amplitude as an animated disk that scales based on the current amplitude of the sound. The highest peak amplitude is visualized as a circle.

The sketch plays the audio file that loops:

```js
sound.play()
sound.setLoop(true)
```

The audio file is loaded the same way as before, but an `Amplitude` object is created and associated with the sound file. 

```js
amplitude = new p5.Amplitude(p.smoothing);
amplitude.setInput(sound);
```
Then, the sketch runs the current amplitude level is computed:

```js
  let level = amplitude.getLevel();

```
This is a floating point (decimal) number between 0 and 1. You may find that audio never reaches 1 due to how the sound file was recorded. You can "normalize" the amplitude level to be 0 to 1 for the current sound file with [`.toggleNormalize(true)`](https://p5js.org/reference/#/p5.Amplitude/toggleNormalize). Try adding this to the end of the `initalizeAnalysis()` function:

```js
// normalization
amplitude.toggleNormalize(true);
```

### Animation Technique Extra

The peak value is rendered using a GreenSock animation with some more advanced usage. The peak level and opacity are all stored in a `peak` object. 

```js
// peak object 
let peak = {
  level: 0,
  opacity: 0,
}
```

The gsap tween has a callback to reset the peak level after the animation finishes, but a new tween "overwrites" any previous ones (i.e. the callback is only triggered when the animation fully completes). 

```js 
// start new animation with callback function on completion
// animated value "opacity" is a member of the object "peak"    
// overwrite: true kills any animation already running
gsap.to(peak, {
    opacity: 0, 
    duration: 1.0, 
    overwrite: true,
    onComplete: function () {
    print(`peak ${peak.level} completed`);
    peak.level = 0;
    }
})
```


## frequency

Demonstrates a variety of frequency-related analysis of a sound file, all based on the Fast Fourier Transform (FFT). The key difference between is that `Amplitude` represents the total "amount" of output at a given point in time, whereas `FFT` represents output across the frequency domain, essentially breaking apart the waveform into separate components. 

Start with this sketch to understand how to analyze frequency spectrums using the [p5.FFT](https://p5js.org/reference/#/p5.FFT) object.


To set up FFT analysis, the demo creates a p5.FFT object like this:

```js
soundFFT = new p5.FFT(p.smoothing, 2 ** p.bins);
soundFFT.setInput(sound);
```

Setting the amount of smoothing and the number of bins is optional, but this demo controls them with the GUI. If you don't call `setInput` with a p5.Sound object, then the FFT analysis will be on all sound produced by the sketch. 

The [p5.FFT](https://p5js.org/reference/#/p5.FFT) methods used:
* `soundFFT.analyze()` performs the FFT analysis on the current sound sample
* `soundFFT.waveform()`
* `soundFFT.getCentroid()` 
* `soundFFT.getEnergy`



## visualize/FFTSpectral

This sketch builds off the previous one, showing a spectrogram-like visualization of the audio file over time.

As with the previous sketch, to update the number of "bands" set with the menu slider, press SPACE. You can also press "p" then SPACE to change the visualization to a polar (radial) visualization.




## visualize/RMSBuffer and visualize/RMSLines

These two sketches are more complex versions of the RMS sketch. They both buffer (keep track of) the volume to show how it has changed over time. Explore both of these sketches to understand how they work.


## Exercise 1

Take one of the visualization sketches and modify it with your own interpretation. Create a short (5–15 second) video demonstrating your resulting composition.


# Synthesis

These sketches demonstrate a variety of ways to get audio file playback.

#### Good Resources

- Algorithmic theory of [music 12-tone system](https://en.wikipedia.org/wiki/Twelve-tone_technique)

### Simple Sound Effects – Samplers/VariableDelay

This simple sketch shows how to use the `Delay` effect in the Processing sound library. Pressing SPACE will play a sound, with parameters of the `Delay` effect controlled by the mouse position. This effect allows you to make a sound echo.

## Synthesizing Sounds – Samplers/SoundsCluster

This sketch shows how to use the `SinOsc` functionality of the Processing sound library to play multiple notes at different frequencies.

Rather than loading audio from a file, this sketch generates the sound itself using an _oscillator_, which is something that produces a repeating waveform, resulting in a sound. The Processing sound library supports four common types of oscillators: sine, square, triangle, and sawtooth.

![SinOsc](img/SinOsc.png)
![SqrOsc](img/SqrOsc.png)
![TriOsc](img/TriOsc.png)
![SawOsc](img/SawOsc.png)

These images show what the waveform produced by each oscillator looks like. The sine wave is a smooth-sounding tone. The square wave sounds reminiscent of wind instruments. The sawtooth wave sounds sharp, and is reminiscent of sounds from vintage video games. More complex sounds can be generated by playing multiple sounds at the same time, or by manually constructing a waveform using the `AudioSample` class.


### Sampling Sound Files – Samplers/SamplerKeyboard

This sketch loads multiple sounds samples and allows them to be played using the computer keyboard like an instrument. It also demonstrates the `Reverb` effect in the Processing sound library, which can make it seem like the sound is playing in a particular kind of space, for example, a large hall.


### Sampling Sound Files – Samplers/SamplerRandom

This sketch is similar to the previous one, but it randomly plays sounds over time, rather than playing sounds in response to keyboard input.


### Sampling Sound Files – Samplers/DrumMachine

This sketch demonstrates how Processing can be used to make a simple drum machine. The output shows a grid of boxes. The columns represent different points in time. The top, middle, and bottom rows correspond to a hi-hat, snare drum, and kick drum sound, respectively. Clicking on a red box will change it to green, and play the corresponding sound at that point in time, on loop.

![simple drum pattern](img/simpledrumpattern.png)

Unlike the other sketches so far, this sketch uses the _Minim_ library, an alternative sound library for Processing that supports more complex features.


## MIDI Sound Generation

This sketch shows how to play a MIDI file using the `javax.sound.midi` library. It also visualizes the notes using 3D graphics – more on that coming in the 3D graphics workshop later in the term!

MIDI stands for _Musical Instrument Digital Interface_, and refers to a number of specifications, including a music file format. MIDI files only store the notes and instruments of a piece of music, like sheet music. This means that the file sizes are very small in comparison to normal audio files like MP3 and WAV. However, it also means that the computer playing the MIDI file needs to have a _sound bank_ with the sounds of different instruments, so it knows how to play it. Due to the compactness of the file format, many early computer music compositions were stored in MIDI or similar (e.g., MOD, XM) formats.



### Using MIDI Notes as Data – Samplers/SamplerMidi

Like the previous sketch, this sketch uses a MIDI file as a data source. But rather than playing the file directly, it plays the notes back manually using a triangle oscillator (see "Synthesizing Sounds" above for more info on oscillators). It also visualizes the note that's being played, similar to "piano roll" editors in many modern music creation software applications. This is an example of how you could use sound information to drive visuals in your assignments.

You'll also notice the variables `attackTime`, `sustainTime`, `sustainLevel`, `releaseTime` in this sketch. These refer to the "attack", "decay", "sustain", "release" (ADSR) envelope, which is ubiquitous in sound synthesis. Adding short fade-ins (attack) and fade-outs (release) can make synthesized sounds seem more natural. By carefully choosing parameter values, you can simulate phenomena like the piano hammer striking the strings in the piano, or plucking strings on a double bass.

The image below shows a visualization of how the four parameters affect the sound. The x-axis represents time; the y-axis represents the amplitude of the generated sound.

![http://cmp.music.illinois.edu/beaucham/software/m4c/M4C_introHTML/M4C_intro.html](img/adsr.png)



### Complex Example – Samplers/Synth

This sketch demonstrates how a synthesizer can be made using Minim, supporting several common synthesizer features.


#### Exercise 2

Take one of the "Samplers" sketches as a starting point. Try loading in your own sound files and changing the way the sound is visualized or played. Create a short (5–15 second) video demonstrating your resulting composition.


## Agents – SoundAgents/AgentSound

An interesting way to create generative music is by introducing random or referential behaviour into the system. One way is to use multiple interacting agents (a kind of [Metacreation](http://metacreation.net/)). This sketch builds off the `agentstarter` code in the previous workshop, to also introduce sound when agents interact.

#### Exercise 3

Take the SoundAgent sketch as a starting point. Try loading in your own sound files. Use one or more of the visualization techniques and/or sampling approaches described above to create a new form of interesting algorithmic playback. Create a short (5–15 second) video demonstrating your resulting composition.


# Entry for Public Digital Sketchbook

Provide a brief (approx. 250 word) description of the visualization and sampling techniques you used in the three exercises above. Attach or link to the three short videos you made in these exercises.

