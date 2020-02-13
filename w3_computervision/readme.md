# Workshop 1: Computer Vision Input

Learn the basics of interactive computer vision using the [OpenCV for Processing library](https://github.com/atduskgreg/opencv-processing). We'll focus on using it to enable different types of body tracking which can be used as input for many kinds of interactive art installations. 

## Goals

* Set up the "OpenCV for Processing" computer vision library.
* Learn basics of computer vision and OpenCV (in Processing) for body tracking:
	* tracking movement with optical flow
	* tracking faces 
	* image processing, thresholding
	* finding "blob" contours using background subtraction and HSB colour tracking, and processing contour data
* Complete small OpenCV programming experiments with the demo code
* Create a small computational artwork that uses the body as input

#### Recommended Reading

**Golan Levin, [Computer Vision for Artists and Designers: Pedagogic Tools and Techniques for Novice Programmers](http://www.flong.com/texts/essays/essay_cvad/)**

* Don't let the "novice programmers" part dissuade you, this is a short but very informative article that relates directly to what we're talking about in this workshop. 
* The technical references are a little out of date.

# Pre-workshop Set Up

Try to complete the following __before__ this Workshop class.

#### 1. Install the "OpenCV for Processing" library

Using `Sketch/Import Library.../Add Library...`, search for the library name and click "Install". 

> **Note that OpenCV is a very large library, so install it where you have a fast connection** (e.g. avoid eduroam at peak times.)

#### 2. Verify your OpenCV installation works

Do this by trying different OpenCV sketch examples using the `File/Examples...` menu. In the window that opens, navigate to the `Contributed Folders/OpenCV for Processing` folder. You'll see a list of  sketches demonstrating different OpenCV features. 

Here are some sketches you should try before class (we'll be using these OpenCv features):

* `LoadAndDisplayImage` is the simplest sketch to make sure the library is installed: it just converts a saved image to greyscale using OpenCV.
* `FilterImages` tests filtering using a still image.
* `MorphologyOperations` tests morphological operators using a still image.
* `FindContours` tests find contours on a still image.
* `BackgroundSubtraction` tests the background subtraction module on a video file.
* `HSVColorTracking` tests your camera with colour tracking (click on something in your video frame that has a bright colour)
* `FaceDetection` tests the face detection module on a still image.
* `LiveCamTest` tests your camera with face detection (also try `WhichFace`)
* `MarkerDetection` tests the marker detection module. This also shows how to use lower level OpenCV methods and classes.

Note some of the included OpenCV examples use other libraries, for example "ImageFiltering" also uses the "ControlP5" library to create the user interface. You should install any extra libraries that are needed. 

> **If everything above works, then you're all set!** 

> **If something didn't work, please post to our Slack channel.** Provide details like what operating system you're using (e.g. MacOSX 10.14.6), what sketch caused the error, what happened when you ran it, and what errors you saw in the console) 

#### 3. Get the latest "Workshop" code from Gitlab

If you have Git installed on your computer, and you already cloned the course workshop gitlab project (see Workshop 0), this could be as easy as typing `git pull` in the terminal. 

# In-Class Workshop

During the workshop, we'll review the Processing code in this directory. Each sketch serves to demonstrate computer vision techniques that could be used to track types of body input. 

> In most cases, the algorithms will not perform perfectly due to variations in lighting, optics, and colours in the environment. This can be minimized by carefully controlling the environment, but your code should still handle tracking errors and noisy input. For this course, the best approach is to assume input will be imperfect, and find a way to harness that in your projects.


## Face Tracking

Sketch: **`face`**

* the `OpenCV` object and `opencv.loadImage`
* scaling down the camera image to speed up computer vision processing (see `scale` variable)
* `flip` to mirror image: for interaction, it's important to use a mirror setup
* `getSnapshot` and displaying output image (including transform)
* debug text (`frameRate`)
* face detection using `opencv.detect` and getting list of face bounding boxes
* other features to track, try code completion on `OpenCV.CASCADE_` or look at [options in documentation](http://atduskgreg.github.io/opencv-processing/reference/gab/opencv/OpenCV.html)

#### Experiments

* Face swap by loading an image and displaying it on top of the tracked face (use a `PImage` and display a scaled version using `image`). There's an emoji image you can use in the `/data` directory.

## Optical Flow

Sketch: **`opticalflow`**

* `calculateOpticalFlow` and `getAverageFlow`
* `PVector`, vector math, and dealing with NaN
* **`PGraphics` object for drawing into an image** (a very useful concept for many projects!)
* adjusting image transparency `tint` and `noTint` 
* importance of providing some subtle feedback


## Image Processing Pipeline

Sketch: **`pipeline`**

* The pipeline paradigm in computer vision 
* Image filters like `blur` to clean up noisy capture frames
* Using native OpenCV (e.g. `Imgproc.medianBlur`)
* Thresholding to get an image mask (`threshold` and `adaptiveThreshold`)
* Morphological operators to clean up noise after thresholding and create a clean image __mask__ (`dilate`, `erode`, `open`, `close`)
* Interactive tweaking of parameters (`adjustX`, `adjustY`)
* Debugging by grabbing debug image at different parts of pipeline

#### Experiments

Use `adjustX` and `adjustY` to change different parameters of the pipeline to create abstract video effects.


## Tracking Blobs and Contours

### Contours

Sketch: **`contours`**

* `adjustX` is morphological closing, `adjustY` is binary threshold
* using `findContours` to detect the contours and return a list 
* drawing contours using `Contour.draw()`
* full contour (in yellow)
* compute an approximate contour with `Contour.getPolygonApproximation()` (drawn in red)
* compute the convext hull of a contour with `Contour.getConvexHull()` (drawn in green)
* compute bounding box of contour with `Contour.getBoundingBox()` (drawn in blue)
* get contour area with `Contour.area()`

#### Experiments

Adjust the lighting, the background in your camera frame, and the pipeline so your body is recognized as a single contour. 


### Colour Isolation

Sketch: **`colour`**

* `useColor()` and `useColor(HSB)`
* getting individual colour channels and assigning then to other `OpenCV` objects
* masking images with `inRange`
* boolean operations using `Core.bitwise_*` functions. [OpenCV reference](https://docs.opencv.org/2.4/modules/core/doc/operations_on_arrays.html#bitwise-and)
* calculating centroid of contour 


#### Experiments

Improve the drawing program so the size of the contour changes the strokeWidth.

* HINT: use map with the area of the contour

(see [Picasso Draws With Light](http://time.com/3746330/behind-the-picture-picasso-draws-with-light/))

# Exercise

Create a body drawing program by extending one of the demos in this workshop. It's ok if it's hard to control, the important thing is that the participant feels like their body movements are somehow making the drawing.

# Extras

These are extra code demos not covered in the workshop, but worth looking at on your own.

## Background Subtraction

Sketch: **`background1`**

* Frame differencing 

> Note: demo is using `opencv.diff` but what's really needed is native OpenCV `absdiff`, but this isn't wrapped in the OpenCV for Processing and I wasn't able to get the native calls working.

Sketch: **`background2`**

* Mixture of Gaussian (MOG) background model

> Note: OpenCV for Processing seems to have a bug with how MOG is wrapped (or there's a bug in OpenCV 2.4). There's no way to adjust the rate that the background model is updated.

[OpenCV reference](https://docs.opencv.org/2.4/modules/video/doc/motion_analysis_and_object_tracking.html?highlight=backgroundsubtractormog#backgroundsubtractormog)

## OpenCV and TensorFlow in P5.js

This site shows how to use OpenCV with P5.js, a JavaScript framework modelled after Processing. It shows examples of more advanced face tracking, object recognition, and body tracking, and more. Many examples use deep learning models via TensorFlow or similar frameworks. 
[https://kylemcdonald.github.io/cv-examples/]()

## Kinect Depth Camera

There are several Processing libraries that interface with the [Microsoft Kinect Depth Camera](https://en.wikipedia.org/wiki/Kinect) (v1 and v2). We have a limited number of these cameras for you to use. Some features will only work on a Windows machine. 

# References and Resources

* [OpenCV for Processing Github](https://github.com/atduskgreg/opencv-processing)
* [OpenCV for Processing reference](http://atduskgreg.github.io/opencv-processing/reference/)

## OpenCV 2.4 C++/Python API 

The "native" API docs are useful for understanding the Processing wrapper and when making direct calls to the native API by importing `org.opencv.imgproc.Imgproc` and calling `Imgproc.*`

* [Documentation](https://docs.opencv.org/2.4/index.html)

* [Thresholding explanation](https://docs.opencv.org/2.4/doc/tutorials/imgproc/threshold/threshold.html)

* [Adaptive thresholding explanation](https://docs.opencv.org/2.4/modules/imgproc/doc/miscellaneous_transformations.html?highlight=adaptive#cv2.adaptiveThreshold)

You can access many of the native OpenCV types with these imports:

```
import org.opencv.core.Core;
import org.opencv.core.Mat;
import org.opencv.core.Size;
import org.opencv.core.Point;
import org.opencv.core.Scalar;
import org.opencv.core.CvType;
import org.opencv.imgproc.Imgproc;
```

See the `HistogramSkinDetection` example sketch included with the OpenCV for Processing library for examples of how to use native commands.
