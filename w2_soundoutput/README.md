# Sound Workshop

Basic Turorials for sound output. 

**Good Resources**

[Vanilla Sound](https://processing.org/reference/libraries/sound/index.html)

[Sound Github Repo](https://github.com/processing/processing-sound)

[Minim Github Repo](https://github.com/ddf/Minim/tree/master/examples)

[Minim Resource](http://code.compartmental.net/minim/audioplayer_class_audioplayer.html)


[Sounds Analysis Tutorial](https://www.youtube.com/watch?v=2O3nm0Nvbi4)


## Preliminaries

Download the `Sound` library and the `Minim` library from Processing's built in library manager. 


## What is sound?

How does sound as a medium differ from the visual? What makes it unique? 

Sound is intrinsically physical and temporal. Ulike lightwaves, sound waves need a physical material to propergate through, and requires a generator (energy needs to be transferred to .  When building compositions, we need to consider how these soundwaves are temporally spaced, the shape of the wave, and how they change over time. There are other properties of course, such as tone, timbre, richness, tempo, and rythm that also need to be considered; but the entire domain of sound can be compacted into dimensions of time, shape, and change.

### The canvas

![https://www.audioreputation.com/audio-frequency-spectrum-explained/](img/Audio-Frequency-Spectrum-Explained.jpg "https://www.audioreputation.com/audio-frequency-spectrum-explained/") 


The human hear has a hearing range that falls between 20Hz to 20kHZ. Though, the what we think of notes will fall into the 60Hz to 6400Hz range, where middle "A" is 440Hz. 

![https://music.stackexchange.com/questions/10472/sound-spectrum-to-notes-software](img/spectrum.jpg "https://music.stackexchange.com/questions/10472/sound-spectrum-to-notes-software")

Another way to visualize the sound spectrum is through analsysis. The image above shows how audio changes over time (x axis) and over the frequency range (y axis). Colour indicates volumn (amplitude). 


## Sound and Generative Art

Sounds, by itself, can be used as generative art. Philippe Pasquier and Arne Eigenfeldt explore this in their research into [Metacreation](http://metacreation.net/). 

For your projects, sound could offer five different utilities:

1. Input generation: seed values as a source of psuedo-randomness. 
2. Output generation: use additive and/or subtractive synthesis as a means of sound output.
3. Visualization: use music information retrival (MIR) to analysis and produce visualization based on intrinsic properties. 
4. Monitoring: use external devices (i.e. microphones) to record or monitor the environment. 
5. Sampling: use pre-recorded audio and manipulation techniques (i.e. effects) to create soundscapes. 


## Visualization

Audio can be visualized in a number of different ways. The basic visualization techniques is to take the amplitude at momenets in time and to use a Fourier transfrom (FFT). Both offer different analysis on what the underlaying audio is doing. 

The key difference between the two, is that `Amplitude` represents the total amount of output at a given time point while `FFT` represents output across the frequency domain, essentially breakng apart the waveform into its individual components. 

For visualization, there are three parameters to interpret: `amplitude`, `frequency`, and `time`. 

```
TODO:
Take one of the visualization sketches and modify it with your own interpretation. 
```

## Samplers

Demonstrates a varietie of ways to get audio file playback. A good resource for sound samples can be found here [FreeSound](https://freesound.org/), midi can be found [here](https://www.classicalarchives.com/midi.html).

Algorithmic theory of [music 12-tone system](https://en.wikipedia.org/wiki/Twelve-tone_technique).

```
TODO:
- Find sound samples, and load them into a sketch. 
- Create Midi, Keyboard, or algorithmic playback. 
```


## Agents

Probally the most interest way to create generative music is when you allow some kind of agent interaction in a kind of [Metacreation](http://metacreation.net/).

```
TODO:
- Take the SoundAgent sketch as a starting point
- Load your own sound files
- Use the visualization techniques, and sampler behaviours to create interesting algorithm playback. 

```



