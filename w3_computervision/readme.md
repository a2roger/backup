# Workshop 3: Computer Vision Input

Learn the basics of interactive computer vision and applied machine learning. We'll primarily focus on different types of body tracking which can be used as input for many kinds of interactive art installations.

> **Make sure you have the latest 383 Workshop code from Gitlab** You should have cloned the course workshop GitLab project to your computer already, so updating is as easy as typing `git pull` in the terminal or selecting "Pull" from the "Source Control" sidebar in VS Code.

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

* This is the first video in a [series about machine learning and ml5](https://thecodingtrain.com/learning/ml5/).

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

There are also various options you can set when initialization the model. 

## Accessing the Predictions

The predictions are stored in a somewhat complicated data structure. I saved an example of it in `predictions.json`.  

It's an array of faces that were detected. For each face, it provides five types of data:

* `faceInViewConfidence`
* `boundingBox`
* `mesh`
* `scaledMesh`
* `annotations`

A description and example of these are in the [Facemesh reference page](https://learn.ml5js.org/#/reference/facemesh), but the example isn't quite right. It seems some of these types of data are enclosed in a single element array for some reason.  For example, this means accessing the top left corner of `boundingbox` requires  this:

```js
let x = predictions[0].boundingBox.topLeft[0][0]
let y = predictions[0].boundingBox.topLeft[0][1]
```

### Performance Considerations

This sketch shows its performance in frames per second (FPS) in the top left of the output window (using the `frameRate` built-in variable). Ideally, this number should be about 60 FPS, but when doing computationally intensive computer vision, this number might reduce drastically. Below around 20 FPS, this latency will start to become readily apparent and could detract from a composition.

### Experiment

* Face swap by loading an image and displaying it on top of the tracked face (use a `PImage` and display a scaled version using `image()`). There's an emoji image you can use in the `/data` directory.

## Optical Flow

Sketch: **`opticalflow`**

This sketch shows a visual representation of the optical flow over a live feed of your computer's webcam. Optical flow represents an estimate of relative motion between multiple image frames over time. Because it depends on changes in image frames, unlike face detection, it doesn't work on individual images. *Optical flow is super useful because it lets you use motion in video input as a way of controlling a composition.* However, it can be rather CPU-intensive (slow).

After setting up OpenCV similarly to the `face` sketch above, this sketch calls the `opencv.calculateOpticalFlow()` method, which computes the optical flow in each cell of the image after it's divided into a grid. We then run
```java
direction = opencv.getAverageFlow();
```
to get the average flow (direction of motion) over the whole image, as a `PVector`. The strength of the motion is encoded as the magnitude of this vector. This vector is visualized as a yellow line in the middle of the output window. We also use `opencv.drawOpticalFlow()` to showcase how the optical flow looks across the different parts of the image. This functionality can be used for debugging purposes.

> *About `PVector`s*: `PVector`s are a useful object representing 2D (or 3D) vectors, built into Processing. The components of the vector are stored in the `x` and `y` fields (e.g. `direction.x` and `direction.y`, in this case). `PVector`s also define a number of helpful methods like `.add()` and `.mult()` for doing operations with multiple vectors.

If you want to get the flow in a specific area of the video feed, you can use can use `getAverageFlowInRegion(x, y, w, h)`. This would enable you to, for example, separate out the motion made by your left hand and by your right hand, by splitting the image down the centre.

If the motion is very small, `opencv.getAverageFlow()` may return a vector with a NaN (invalid) `x` or `y` value. This sketch uses `Float.isNaN()` as follows to make sure this doesn't happen:
```java
if (Float.isNaN(direction.x) || Float.isNaN(direction.y)) {
  direction = new PVector();
}
```

> Note: This sketch draws the camera image semi-transparently above the background. It uses the `tint(grey_value, alpha_transparency)` built-in function to set the transparency, and `noTint()` to restore it.

#### Drawing with Optical Flow

Try setting the `makeDrawing` global variable to true. This uses the average optical flow (`direction`) to enable a line to be drawn following the direction of motion. Try writing on the output window by moving your hand around in the view of the camera.

In `draw()`, we draw a line from a previous position to a new position moved in the direction of the optical flow. Rather than drawing this line directly on the screen, we use a `PGraphics` object stored in the global variable `vis` as a buffer. This buffer is then drawn to the output window each frame. `PGraphics` are transparent graphics buffers that have the same drawing functions as the output window, like `stroke()` and `line()`. By having a separate buffer for the pixels drawn by these lines, we don't have to manually maintain a list of previously drawn points. *`PGraphics` are a very useful concept that can be applied in many projects.*


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

#### Experiments

Use `adjustX` and `adjustY` to change different parameters of the pipeline to create abstract video effects.


## Tracking Blobs and Contours

### Contours

Sketch: **`contours`**

This sketch outlines different contours identified in a live feed of your computer's webcam. Contours are curves along regions with similar colours and lightness. With proper thresholding, you can use contour finding to track the outline of your arms or fingers as in works like *Text Rain* (Camille Utterbak and Romy Achituv, 1999) and *Hand From Above* (Chris O'Shea, 2009).

To find the contours, this sketch calls the `opencv.findContours()` method. It takes two boolean parameters: the first controls whether to find nested contours (holes in other contours), the second controls whether to sort the resulting contours by size in descending order. The method returns all the identified Contours as an `ArrayList` of `Countour`s (a type built into the Processing OpenCV library).

In `draw()`, we iterate through each of the contours and draw them in yellow. To draw the full contour directly, we just call `c.draw()`, where `c` is the contour. The library also provides methods to get simplified versions of the contour:
* An approximate contour can be obtained with `Contour.getPolygonApproximation()` (drawn in red in the output window). This approximation retains most of the details of the full contour, but contains much fewer points and is therefore easier to process.
* A convext hull of the contour can be obtained with `Contour.getConvexHull()` (drawn in green in the output window). The convex hull is the smallest convex shape that contains the contour, kind of as if you were to wrap a string or rubber band around it.
* A bounding box of contour can be obtained with with `Contour.getBoundingBox()` (drawn in blue in the output window).

The area of a contour can be obtained with `Contour.area()`. We use this method in this sketch to ignore contours below a certain size.

Like the previous `pipeline` sketch, this sketch also uses the mouse to tweak filter parameters. `adjustX()` controls morphological closing, `adjustY()` controls binary threshold.

#### Experiments

Adjust the lighting, the background in your camera frame, and the pipeline so your body is recognized as a single contour.


### Colour Isolation

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


#### Experiments

Improve the drawing program so the size of the contour changes the strokeWidth.

> Hint: Use `map()` with the area of the contour.

(See [*Picasso Draws With Light*](http://time.com/3746330/behind-the-picture-picasso-draws-with-light/).)

# Exercise for Public Sketchbook

Create a body drawing program by extending one of the demos in this workshop. It's OK if it's hard to control, the important thing is that a participant would feel like their body movements are somehow making the drawing. Capture and include a short video your program's output, and provide a brief (approx. 250 word) description of how you use input and what computer vision approaches you apply.

# Extras

These are extra code demos not covered in the workshop, but worth looking at on your own.

## Background Subtraction

Sketch: **`background1`**

* Frame differencing (press a key to set the background frame)

> Note: The demo is using `opencv.diff` but what's really needed is native OpenCV `absdiff`, but this isn't wrapped in the OpenCV for Processing and we aren't able to get the native calls working.

Sketch: **`background2`**

* Mixture of Gaussian (MOG) background model

> Note: OpenCV for Processing seems to have a bug with how MOG is wrapped (or there's a bug in OpenCV 2.4). There's no way to adjust the rate that the background model is updated.

[OpenCV reference](https://docs.opencv.org/2.4/modules/video/doc/motion_analysis_and_object_tracking.html?highlight=backgroundsubtractormog#backgroundsubtractormog)

## OpenCV and TensorFlow in P5.js

This site shows how to use OpenCV with P5.js, a JavaScript framework modelled after Processing. It shows examples of more advanced face tracking, object recognition, and body tracking, and more. Many examples use deep learning models via TensorFlow or similar frameworks.
[https://kylemcdonald.github.io/cv-examples/](https://kylemcdonald.github.io/cv-examples/)

## Kinect Depth Camera

There are several Processing libraries that interface with the [Microsoft Kinect Depth Camera](https://en.wikipedia.org/wiki/Kinect) (v1 and v2). Some features will only work on a Windows machine.

# References and Resources

* [OpenCV for Processing Github](https://github.com/atduskgreg/opencv-processing)
* [OpenCV for Processing reference](http://atduskgreg.github.io/opencv-processing/reference/)

## OpenCV 2.4 C++/Python API

The "native" API docs are useful for understanding the Processing wrapper and when making direct calls to the native API by importing `org.opencv.imgproc.Imgproc` and calling `Imgproc.*`

* [Documentation](https://docs.opencv.org/2.4/index.html)

* [Thresholding explanation](https://docs.opencv.org/2.4/doc/tutorials/imgproc/threshold/threshold.html)

* [Adaptive thresholding explanation](https://docs.opencv.org/2.4/modules/imgproc/doc/miscellaneous_transformations.html?highlight=adaptive#cv2.adaptiveThreshold)

You can access many of the native OpenCV types with these imports:

```java
import org.opencv.core.Core;
import org.opencv.core.Mat;
import org.opencv.core.Size;
import org.opencv.core.Point;
import org.opencv.core.Scalar;
import org.opencv.core.CvType;
import org.opencv.imgproc.Imgproc;
```

See the `HistogramSkinDetection` example sketch included with the OpenCV for Processing library for examples of how to use native commands.
