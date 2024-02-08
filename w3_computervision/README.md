# Workshop 3: Computer Vision Input

Learn the basics of interactive computer vision and applied machine learning. We'll primarily focus on different types of body tracking which can be used as input for many kinds of interactive art installations.

## Goals

1. Learn about the [ml5.js](https://learn.ml5js.org/#/) library for computer vision tracking:
	* tracking faces using different ML models
	* tracking hands
	* tracking a whole body pose
	* background segmentation

2. Learn about the [p5.js-cv](https://github.com/orgicus/p5.js-cv) wrapper for opencv.js 
	* tracking movement with optical flow
	* image processing, thresholding
	* finding "blob" contours using background subtraction and HSB colour tracking, and processing contour data

3. Learn about other p5.js techniques and other JavaScript libraries for image processing and tracking:
   * AR marker tracking

4. Complete small programming experiments with the demo code
  
5. Create a small coding exercise that uses the body as input

## Recommended Viewing and Reading 

**Daniel Shiffman's video ["A Beginner's Guide to Machine Learning with ml5.js"](https://youtu.be/jmznx0Q1fP0).** He introduces the ml5 library and explains key concepts behind behind machine learning.

* This is the first video in a [series about machine learning and ml5](https://thecodingtrain.com/tracks/ml5js-beginners-guide).

**Golan Levin, [Computer Vision for Artists and Designers: Pedagogic Tools and Techniques for Novice Programmers](https://link-springer-com.proxy.lib.uwaterloo.ca/article/10.1007/s00146-006-0049-2)** (UW Library link, alternatively [an archived version available through the Internet Archive](https://web.archive.org/web/20120330064719/http://www.flong.com/texts/essays/essay_cvad/))

* Don't let the "novice programmers" part dissuade you, this is a short but very informative article that relates directly to what we're talking about in this workshop.
* The code examples use Java Processing and the technical references are out of date.

## Resources

* [ml5.js - Friendly Machine Learning for the Web](https://ml5js.org/): a multi-purpose JavaScript library that packages up many different machine learning models and methods. Has built-in support for p5.js.

* [p5.js-cv](https://github.com/orgicus/p5.js-cv): a p5.js port of Kyle McDonald's ofxCv library using opencv.js.
  
* [Kyle McDonald's cv-examples](https://kylemcdonald.github.io/cv-examples/): various computer vision demos using both built-in p5.js image processing and different machine learning libraries.

* [An Introduction to Computer Vision in JavaScript using OpenCV.js](https://www.digitalocean.com/community/tutorials/introduction-to-computer-vision-in-javascript-using-opencvjs): a lower level introduction to using opencv.js with standard JavaScript

# General Advice

In most cases, the algorithms will not perform perfectly due to variations in the environment and your hardware. 

**Environment:** The framing of the subject, the brightness and consistency of lighting, and background colours and textures can  all affect tracking quality. This can be minimized by carefully controlling the environment, but your code should still handle tracking errors (i.e. lost tracking) and noisy input. 

**Technical:**  Some methods are affected by the quality of your camera and the processing speed of your computer. Camera quality can be improved by improving your environment (see above). We'll look at ways to reduce the size of the captured image frames to compensate for computer speed. 

For this course, the best approach is to assume input will be imperfect, and find a way to harness that in your projects.

# ml5 Tracking

Computer vision techniques to track different types of body input. 

## Face Tracking 

Sketch: **`face1`**

This sketch shows a live feed of your computer's webcam, and draws a box around any faces that are detected in the view. It uses the [Facemesh machine learning model](https://learn.ml5js.org/#/reference/facemesh), ml4 describes it as:

> "Facemesh is a machine-learning model that allows for facial landmark detection in the browser. It can detect multiple faces at once and provides 486 3D facial landmarks that describe the geometry of each face. Facemesh works best when the faces in view take up a large percentage of the image or video frame and it may struggle with small/distant faces."

### Initializing the model

In draw, create a p5.js video capture object as usual, then initialize the ml5 model to process video from that object and save a reference to the model in a global variable:

```js  
facemesh = ml5.facemesh(video, modelReady);
```

`modelReady` is an optional callback function that is executed when the model was loaded. Also in draw, add a callback function to the facemesh model:

```js
  facemesh.on("predict", results => {
    predictions = results;
  });
```

This means that each time a "predict" event is triggered inside the model, it should update the global variable with all the predictions for that frame. The predictions will be all the information for faces the model found in the scene, such as eye position, bounding box of each face, etc. 

There are also various options you can set when initializing the model. 

## Accessing the Predictions

The predictions are stored in a somewhat complicated data structure. I saved an example of it in `predictions.json`.  

> **[JavaScript Object Notation (JSON)](https://www.json.org/json-en.html)** is a standard text-based format for representing structured data based on JavaScript object syntax. 

It's an array of faces that were detected. For each face, it provides five types of data:

* `faceInViewConfidence`
* `boundingBox`
* `mesh`
* `scaledMesh`
* `annotations`

A description and example of these are in the [Facemesh reference page](https://learn.ml5js.org/#/reference/facemesh), but the example isn't quite right. **It seems some of the data are enclosed in a single element array.**  Below is a reduced version of the predictions json returned by the model. You can see the nested square brackets right after `leftCheek`, for example. 

```json
[
    {
		"annotations": {
			"rightCheek": [
				[
					268.2108154296875,
					306.60540771484375,
					4.016082286834717
				]
			],
			"leftCheek": [
				[
					360.81134033203125,
					301.05767822265625,
					-1.433227777481079
				]
			]
		}
	}
],
```

This code extracts the x, y, and z coordinates of the `leftCheek` annotation of the first face):

```js
let pts = predictions[0].annotations['leftCheek'][0]
```

The x and y coordinates are the first and second element in the `pts` array:

```js
let x = pts[0]
let y = pts[1]
```

There's a coding convention in JavaScript called "destructuring" to assign array element values to multiple variables like this:

```js
let [x, y] = pts
```
> **JavaScript TIP:** In the code, you might see variables defined with `let`, `const`, and even `var` or nothing. Defining a variable with `const` means make a variable constant: meaning the code will not change it later. `let` means make the variable "mutatable": meaning the code can change it later. Defining with `var` or nothing at all is generally considered bad practice.

Since we have an array of faces in the predictions json, we usually *iterate* through each face prediction in a loop:

```js
// p will each face in the array
predictions.forEach((p) => {
	// now we can get the x and y coordinates in one step
	let [x, y] = p.annotations['leftCheek'][0]
	// using those x and y coordinates, we can do something
	...
});
```

### Performance Considerations

This sketch shows its performance in frames per second (FPS) in the top left of the output window (using the `frameRate` built-in variable). Ideally, this number should be about 60 FPS, but when doing computationally intensive computer vision, this number might reduce drastically. Below around 20 FPS, this latency will start to become readily apparent and could detract from an artwork.

With ml5, the prediction rate isn't directly tied to the framerate. This means your video frames may "get ahead" of the prediction, since a few video frames will be rendered before the next prediction arrives. 

### Exercise

Let's write some code to do a simple "face swap" with an emoji.

1. Load the emoji image in the data folder:

   ```js
   let emoji;

   function preload() {
      emoji = loadImage('data/emoji.png')
   }
   ```

2. Create a function called `faceSwap` and call it from `draw`.

3. In your faceSwap function, iterate through all predictions: 

	```js
	predictions.foreach((p)) => {
		
	});
	```

4. In each loop iteration, get the value of the `leftCheek` and `rightCheek` annotated points:
   
	```js
	const [lx, ly] = p.annotations['leftCheek'][0]
	const [rx, ry] = p.annotations['rightCheek'][0]
	```

5. Draw a line between those points to make sure everything is working:

	```js
    stroke('#ff0000')
    strokeWeight(10)
    line(lx, ly, rx, ry)
	```

	You should see a thick red like that looks a bit like a "mustache".


6. Find the midpoint between those two points:

	```js
	const x = (lx + rx) / 2
	const y = (ly + ry) / 2
	```

7. Draw the emojii image centred at the midpoint:
   
   ```js
   image(emoji, x, y)
   ```

   This won't look quite right, by default p5 displays images using the top left corner position. 

8. We could do some math and move the image up, but p5 also has a way of changing what part of the image is used for positioning. Change your code to this:

	```js
	push()
    imageMode(CENTER)
    image(emoji, x, y)
    pop()
	```

	It's important to save the state of the drawing context with `push()` then restore it after with `pop()`. This will return the imageMode back to CORNER, if you don'
	t, your video frame will also be displayed from the center.

	This looks ok, but the 200 by 200 emoji size doesn't change when you move farther or close to the camera. 

9. Let's use the distance between the left and right cheek points to change the scale of the emoji. We need to calculate the distance, then multiply that by something to make the emoji big enough to cover your real face. I found a factor of 2.8 works  well for me, but you can adjust that.

	```js
	let d = dist(lx, ly, rx, ry) * 2.8
	```

	Then use d when you draw the emoji image:

	```js
    image(emoji, x, y, d, d)
	```

	This looks better, but we could make the emoji rotate a bit to match the angle of your face too.

10. Use `atan2` to find the angle of the left to right cheek line relative to the x-axis:

	```js
	let a = atan2(ly - ry, lx - rx) 
	```

	Remember that atan2 arguments are `y` then `x`!

11. We can use that angle to *transform* the emoji image. We want to rotate around 0,0, not around the x,y position of the emoji image in the scene, so we also need to move the x,y position to a translate that is applied after rotate. Like this:

	```js
	push()
	translate(x, y) // this will be applied second
	rotate(a) // this will be applied first
	image(emoji, 0, 0, d, d) // draw image at 0,0
	pop()
	```

	> **RESOURCE:** You may want to review translations, see the csfine383 resources repo. 
 
12. This is looking better, but the emoji still sits a bit low. We can easily tweak the position using our translate transformation. I found moving it up by one quarter of the distance between left and right cheek worked well for me. 

	Edit the translate function call to be this:

	```js
	translate(x, y - d/4)
	```

**More tweaks are possible.** For example, we could use a third feature to get the perspective of the face. Then we could scale the width and height of the emoji differently to make the emoji look like its more 3D.

## Hand Tracking

Sketch: **`hand`**

Tracks a **single** hand using a very similar structure to face.

The predictions use a json format very similar to face.


## Body Tracking

Sketch: **`body`**

Tracks multiple bodies using a very similar structure to face.

The predictions use a json format that's somewhat different than face.


# Other Tracking

## Optical Flow

Sketch: **`opticalflow`**

This sketch shows a visual representation of the optical flow over a live feed of your computer's webcam. Optical flow represents an estimate of relative motion between multiple image frames over time. Because it depends on changes in image frames, unlike face detection, it doesn't work on individual images. *Optical flow is super useful because it lets you use motion in video input as a way of controlling a composition.* However, it can be rather CPU-intensive (slow).


> `p5.Vector` is a useful object representing 2D (or 3D) vectors, built into p5.js. The components of the vector are stored in the `x` and `y` fields (e.g. `direction.x` and `direction.y`, in this case). A `p5.Vector`  also defines a number of helpful methods like `.add()` and `.mult()` for doing linear algebra operations.

<!-- If you want to get the flow in a specific area of the video feed, you can use can use `getAverageFlowInRegion(x, y, w, h)`. This would enable you to, for example, separate out the motion made by your left hand and by your right hand, by splitting the image down the centre. -->


> Note: This sketch draws the camera image semi-transparently above the background. It uses the `tint(grey_value, alpha_transparency)` built-in function to set the transparency, and `noTint()` to restore it.

### Drawing with Optical Flow

Try setting the `makeDrawing` global variable to true. This uses the average optical flow (`direction`) to enable a line to be drawn following the direction of motion. Try writing on the output window by moving your hand around in the view of the camera.

In `draw()`, we draw a line from a previous position to a new position moved in the direction of the optical flow. Rather than drawing this line directly on the screen, we use a `p5.Graphics` object stored in the global variable `viz` as a buffer. This buffer is then drawn to the output window each frame. `p5.Graphics` are transparent graphics buffers that have the same drawing functions as the output window, like `stroke()` and `line()`. By having a separate buffer for the pixels drawn by these lines, we don't have to manually maintain a list of previously drawn points. **Using a `p5.Graphics` buffer for drawing is a very useful concept that can be applied in many projects.**


## Fiducial Marker Tracking

Sketch: **`marker`**

Using [JSARToolKit](https://github.com/kig/JSARToolKit)

[Introduction guide](https://www.html5rocks.com/en/tutorials/webgl/jsartoolkit_webrtc/)




<!-- 
# OpenCV

## Image Processing Pipeline

Sketch: **`pipeline`**

This sketch demonstrates the computer vision pipeline and showcases some image filters that OpenCV can apply.

Computer vision approaches often follow a "pipeline" paradigm, in which there are multiple distinct stages. Here is a four stage decription of such a pipeline:

1. *Data input*: In the sketches so far, this data has been sourced from your computer's webcam, but static images or videos could also be used.
2. *Pre-processing*: Preparing the data for being processed, doing things like simplifying colours, scaling, and reducing noise.
3. *Processing*: For example, doing face tracking or contour tracking.
4. *Using the processed data*: The faces/contours/etc. found in the previous step could drive different parts of an artwork. (Outside an art context, this step might involve something like machine learning clasification or event monitoring.)

This sketch uses blur and median blur image filters to clean up noisy capture frames. The Processing OpenCV library provides a number of filter functions on the `OpenCV` object, like `blur`, `dilate`, and `erode` (the latter two are explained below). It also supports using lower level "native" OpenCV functions. As an example, this sketch shows how the `Imgproc.medianBlur()` function can be used.

After slightly blurring the image to remove noise and sharp edges, we apply a *threshold* filter to make an image *mask*. The most basic threshold, `opencv.threshold(cutoff)`, simply makes any pixels below the cutoff value black, and any pixels above the cutoff value white. The `opencv.adaptiveThreshold()` function can be used to apply a threshold locally to smaller parts of the image. This is useful when the lighting is different across different parts of the image.

After applying the threshold filters, we can apply morphological operations, such as `dilate`, `erode`, `open`, and `close`. These can help clean up noise after thresholding to create a cleaner image mask. Here is a brief description of each of these operations:
- `erode`: shrinks bright regions
- `dilate`: grows bright regions
- `open`: erode then dilate
- `close`: dilate then erode

(The OpenCV documentation has some [great interactive demos](https://docs.opencv.org/master/d4/d76/tutorial_js_morphological_ops.html) for further information.)

This sketch uses the mouse x and y position to tweak two separate filter parameters, via the `adjustX()` and `adjustY()` functions at the bottom of the sketch code. `mouseX` controls the aperture (intensity) of the median blur filter. `mouseY` controls the threshold filter's cutoff value. 

> Hint: As mentioned above, `opencv.getSnapshot()` can be used to grab an image at different parts of pipeline. This is helpful for debugging. Try moving the `debug = opencv.getSnapshot();` line before the `Imgproc.medianBlur()` line to see how the output changes.

### Experiments

Use `adjustX` and `adjustY` to change different parameters of the pipeline to create abstract video effects. -->


# Tracking Blobs and Contours

## Contours

~~Sketch: **`contours`**~~ <- demo seems to be broken

~~Uses p5.cv.js, an opencv.js wrapper.~~


Sketch: **`contours-cv`**

This sketch outlines different contours identified in a live feed of your computer's webcam. Contours are curves along regions with similar colours and lightness. With proper thresholding, you can use contour finding to track the outline of your arms or fingers as in works like *Text Rain* (Camille Utterbak and Romy Achituv, 1999) and *Hand From Above* (Chris O'Shea, 2009).

<!-- To find the contours, this sketch calls the `opencv.findContours()` method. It takes two boolean parameters: the first controls whether to find nested contours (holes in other contours), the second controls whether to sort the resulting contours by size in descending order. The method returns all the identified Contours as an `ArrayList` of `Countour`s (a type built into the Processing OpenCV library).

In `draw()`, we iterate through each of the contours and draw them in yellow. To draw the full contour directly, we just call `c.draw()`, where `c` is the contour. The library also provides methods to get simplified versions of the contour:
* An approximate contour can be obtained with `Contour.getPolygonApproximation()` (drawn in red in the output window). This approximation retains most of the details of the full contour, but contains much fewer points and is therefore easier to process.
* A convext hull of the contour can be obtained with `Contour.getConvexHull()` (drawn in green in the output window). The convex hull is the smallest convex shape that contains the contour, kind of as if you were to wrap a string or rubber band around it.
* A bounding box of contour can be obtained with with `Contour.getBoundingBox()` (drawn in blue in the output window).

The area of a contour can be obtained with `Contour.area()`. We use this method in this sketch to ignore contours below a certain size.

This sketch uses the mouse to tweak filter parameters. `adjustX()` controls morphological closing, `adjustY()` controls binary threshold. -->

### Experiments

Adjust the lighting, the background in your camera frame, and the pre-processing so your body is recognized as a single contour.


<!-- ## Colour Tracking

Sketch: **`colour`**

This sketch shows how a region of colour can be tracked and used for input. Click the mouse on an object of a unique colour in the view of the webcam to track it.

The general approach this sketch uses to track objects based on colour is to create a mask encoding regions of the image that have a similar hue to the selected hue. It then uses `opencv.findContours()` and computes the centroid of the largest contour to track its position.

After getting the RGB (red-green-blue) image to display in the output window with `opencv.getSnapshot()`, we change OpenCV's colour mode to HSB (hue-saturation-brightness) with `opencv.useColor(HSB)`. This enables us to process these channels individually later on using `opencv.getH()`, `opencv.getS()`, and `opencv.getB()`.

We extract out the individual HSB channels into separate OpenCV objects, using calls like:
```java
frameH.setGray(opencv.getH().clone());
```
From this, we can filter out values we don't want by masking the channels with `inRange(lowerBound, upperBound)`. This method works like `threshold()`, but rather than having a single cutoff, there is a lower bound and an upper bound. Any pixel with a brightness between the two bounds becomes white, and other pixels become black. In the case of this sketch, we mask out colours that are too far away in hue, too unsaturated, or too dark. We then use the bitwise and boolean operation to compute the *intersection* of all these masks (i.e. pixels that match all of these criteria). OpenCV supports other boolean operations using `Core.bitwise_*` functions ([OpenCV reference](https://docs.opencv.org/2.4/modules/core/doc/operations_on_arrays.html#bitwise-and)).

Finally, like the `contours` sketch above, this sketch finds the contours in the mask. It calculates the centroid of the largest contour using the `calcCentroid()` function near the bottom of the sketch code. This function returns the average position of a list of points.


### Experiments

Improve the drawing program so the size of the contour changes the strokeWidth.

> Hint: Use `map()` with the area of the contour.

(See [*Picasso Draws With Light*](http://time.com/3746330/behind-the-picture-picasso-draws-with-light/).) -->

# Sketchbook Exercise

Create a body drawing program by extending one of the demos or exercises in this workshop. It's OK if it's hard to control, the important thing is that a participant would feel like their body movements are somehow making the drawing. Capture and include an image of your artwork (or series of images or even a short video) and provide a brief (approx. 250 word) description of how you use input and what computer vision approaches you apply.
