# Sound Workshop

Basic Turorials for sound output. 

**Good Resources**

[Vanilla Sound](https://processing.org/reference/libraries/sound/index.html)

[Sound Github Repo](https://github.com/processing/processing-sound)

[Minim Github Repo](https://github.com/ddf/Minim/tree/master/examples)

[Minim Resource](http://code.compartmental.net/minim/audioplayer_class_audioplayer.html)


## Preliminaries

Download the `Sound` library and the `Minim` library from Processing's built in library manager. 


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



