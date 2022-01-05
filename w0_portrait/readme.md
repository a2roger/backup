# Workshop 0: Portrait

Create an interactive portrait of yourself.

## Goals

* p5.js basics 
* Test camera capture
* Make something simple and creative to warm up your coding

## Setup

For this first workshop, we'll use the [p5.js online editor](https://editor.p5js.org/). This a good tool for small tests and experiments, and it makes sharing code really easy. For more serious development, we'll be using Visual Studio Code with a local server and browser-based debugging. More about that later.   


# Workshop

In this workshop you'll create a simple interactive "portrait" using images captured from your webcam. Before we show you how to capture your own images, we'll start with a demo with images I captured of myself. 


## Portrait

Open the `portrait1` sketch in the p5.js online editor:
[https://editor.p5js.org/csfine383/sketches/_soHMb4Wz]

> The p5.js community likes to call computer programs "sketches".

This loads a sequence of png files and displays them according to the mouse position. 

Press the round play button. After a brief "Loading Images..." message you'll see my images in a little square (called the "canvas"). Now move your mouse left and right.

### p5.js Online Editor

When you clicked on that link you really opened a copy of the sketch I created. You can freely change the code in the page, but you can't save it back to my copy. If you refresh the page, you'll get my version again. 

If you want to save your own version of the sketch, then you need to create an account with the p5.js editor. It's free and easy to do. Once you're signed in, you can save. Once my sketch is saved to your account, it's no longer connected to my version. 

### Web-based Programming

p5.js runs as code in a webpage hosted on a webserver. This changes the programming model a bit when it comes to loading and saving data.

This sketch has a `preload` function in which the png frames are loaded from the web server (in this case, the server is hosted and managed by the p5. js editor ). We use preload to make sure all images are loaded and ready to use before the main part of the program starts. 

All the png frames were already uploaded to the p5.js editor server. You can see all the files associated with this sketch by clicking the grey `>` button just below the round play button.  You'll see the frames in the `/data` directory. 

### Experiments

The current version uses the mouseX position to pick a frame to display. The calls to map, int, and constrain make this mapping.

The effect is almost like the mouse cursor is dragging my head back and forth, but of course it's just an illusion created by how I captured the frames and how I mapped the frame to display to my mouse position. 

**What other illusions could you create with this basic idea of capturing frames in a certain way and mapping them to the mouse?**

Another way to turn this series of frames into a computational artwork is to create a **drawing tool**. Try changing the code code that displays the image to this: 

```js
// use mouseY for the image x-position
image(images[i], mouseY, 0)
```

This creates a kind of [slit-scan](https://en.wikipedia.org/wiki/Slit-scan_photography) renderer that you could use to generate abstract portraits. 

**What other interactive re-mixing and compositing of the frames could you create by using the mouse position to transform and render  all or part of the frames?**

We can also add some code to **explore the medium** itself.

Add a global variable `d` and change the `draw` function code to this:

```js
// accumulate distance here
let d = 0;

function draw() {
  
  // accumulate distance the mouse moved each draw frame
  d += dist(pmouseX, pmouseY, mouseX, mouseY) / 500
  // convert it to an image frame index 
  i = int(d) % frameNum
  // display the current image 
  image(images[i],0,0)
  // show values to see what's going on
  print(d, i)
}
```

This displays each frame based on how far the mouse moves. To display the images at a reasonable speed, the user has to move their mouse really fast which requires some effort. This could make users think about how passive they normally are when viewing videos, perhaps a social-cultural statement about media consumption. Doing something well understood in an intentionally wrong or unusual way (e.g. "counter functional") can create a thought-provoking experience.

**How else could you change how a user views a simple video loop?**


## Recorder

The `recorder` sketch is used for recording a sequence of frames to use in your main "portrait" sketch:
https://editor.p5js.org/csfine383/sketches/mQTObu5U5

* The code isn't pretty, this is really more of a tool for you to use. 
* Only a 256 by 256 crop of the video from your camera is shown and saved. Adjust `offsetX`, `offsetY`, and `scaleXY` to get it positioned how you want. 
* **r for new recording**: press SPACE to capture one frame at a time
* **p for playback**: press p to play the frames
* **d for download**: press d then (slowly) press SPACE to save each frame as png to your own computer.
* * If you're asked for a filename or location to save each time, you should be able to change a setting in your browser to avoid that.
* There may be a limit to how many frames can be downloaded, I suggest you stick to about 30 or less.

### Loading your frames into the portrait sketch

In you `portrait` sketch on the p5.js online editor:
* open the /data directory
* delete all the old frames OR use a different filename prefix for your new frames  OR rename the data directory and create a new one OR delete the current data directory to delete the files quickly and create data again
* set the `frameNum` variable to the number of frames you uploaded

> The program expects the frame filenames to be png and formatted like this `frame1.png`.

# Exercise

* Capture a sequence of your own portrait images.
* Modify the `portrait1` sketch to load and display the frames in a new way. The sketch should use simple mouse movement to make it interactive. 
* Save your sketch in the p5.js editor and share the link in the Teams #general channel before next class.

## Sketchbook Entry

Paste some screen captures of the images produced by your portrait code.
Briefly describe the results of your exercise, including a brief description of what you changed and how your code works.
