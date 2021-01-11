# Workshop 0: Portrait

Create an interactive portrait of yourself.

## Goals

* GitLab setup
* Processing install with libraries
* Test camera capture
* Make something creative to warm up your coding

# Workshop Set Up

## Processing

1. Download the latest Processing https://www.processing.org/
    * Test your installation by running an example using menu `File/Examples...`
2. Install Video library
    * In Processing, open `Sketch/Import Library.../Add Library...`
    * search for "Video" and click "Install"


## Gitlab and Git

1. Sign-in to the UWaterloo Gitlab site:
    * https://git.uwaterloo.ca

2. Make sure you have access to the workshop code:
    * https://git.uwaterloo.ca/csfine383/workshops

3. Setup git on your local machine
    * We created a [**guide for using git in 383**](https://git.uwaterloo.ca/csfine383/HowTosAndOtherThings/blob/master/Manuals/GitManual.md).

## Get the Workshop Code

1. It's easiest if you clone the workshop code into your Processing folder. 
    * Open Processing Preferences to find out where your "Processing Sketchbook" lives (you can change the location too).

2. Create a directory for all the workshop code, like `/workshops` 

3. Clone the workshop repository to pull the code into this directory.
    * In a terminal or command line, change to the workshop code directory you created in step 2.
    * Clone the gitlab workshop repo with a command like this (replace username with your Quest login name, e.g. jdoe):
        ```
        git clone https://username@git.uwaterloo.ca/csfine383/workshops.git
        ```

<!-- > NOTE: Please don't push changes from your copy of the course code back to the repo. We need to fix permissions and show you how to create your own repos. The best way to handle this is to treat your local copy of the couse workshop code as "readonly" and then create a different place to put your own code. -->

> NOTE: **If you get stuck with using git,** you can also grab the code using the "Download Code" button near the upper right of the project page. But ask us how to get git working, it makes it much easier to get updates and you'll be using git to submit your assignments.

### Note about Markdown files

You'll notice that our code repo has `readme.md` files. These are just text files that can be opened in any text editor. However, these are also special text files that can be rendered with nice looking headings, links, even images. The `md` means "markdown", which is the language used to indicate what's a heading, a bullet, a link, etc. Think of markdown as a really simple format for HTML, that can be easily read as plain text.

If you want to view rendered version of `md` files on your own computer, try [_Markoff_, a free markdown viewer for OSX](https://robots.thoughtbot.com/markoff-free-markdown-previewer).


# Workshop

You'll find all the code for Workshop 0 in the `w0_portrait/` directory. If you `git clone`d all the workshop code in the "Processing Sketchbook" directory, then you can open it using the `File/Sketchbook...` menu. Otherwise navigate the folder and double click the `.pde` file.

## Recorder

The `recorder` sketch is used for recording a sequence of frames to use in your main "portrait" program. It uses the Video library to capture frames.

* Run the sketch and see if your video works. If not, see the comments in the code for ideas for adjustments to make it work.
* Only a 256 by 256 crop of the video is shown and saved. Use the mouse to drag the full frame around to position it.
* Pressing space saves a single frame, hold it down to capture a sequence.
* By default, it only saves up to 30 frames.

> NOTE: If you're using a recent version of macOS (Catalina or newer) and get an error similar to `terminating with uncaught exception of type NSException Could not run the sketch`, make sure you have the latest version of Processing and the video library. If it still doesn't work, contact us and we can debug the problem together.

## Portrait

The `portrait*` sketches are what you'll use as a starting point. Each loads the frames saved with recorder and then presents the frames in some varied way based on mouse position.

## Gif Animation

The `portrait1` sketch shows how to generate a GIF animation from Processing. You can integrate this code into the other portrait sketches if you use them as a starting point.

It uses the [GifAnimation library](https://github.com/extrapixel/gif-animation/tree/3.0): you have to install this manually (do not install it using the Processing IDE). 
1. Locate your "Processing Sketchbook" location. On a Mac, this is in the dialog opened by the "Processing/Preferences". On Windows, this is under "File/Preferences".
1. Go to that folder and open the `libraries` subfolder. 
1. Download the `GifAnimation.zip` and unzip it. 
1. Drag the `gifanimation` subfolder of extracted zip to the Sketchbook `libraries` subfolder. 
1. Restart Processing. 


# Exercise

* Modify one of the `portrait` sketches to load and display the frames in a new way. The sketch should use simple mouse movement to make it interactive (just `mouseX` and `mouseY`). 

* Create your own UWaterloo Gitlab project and push your code.

* Generate a GIF animation and share it in the Public-Sketchbook channel in Teams. Describe the results of your exercise, including a brief description of what you changed and how your code works.
