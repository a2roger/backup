# Workshop 0: Portrait

Create an interactive portrait of yourself.

## Goals

* GitLab setup
* p5.js setup 
* Test camera capture
* Make something creative to warm up your coding

# Workshop Set Up

## p5.js

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
    * We created a [**guide for using git in 383**](https://git.uwaterloo.ca/csfine383/resources/blob/master/manuals/git-setup.md).

## Get the Workshop Code

It's easiest if you clone all the CS/FINE 383 workshop code onto your local machine. 

1. Create a directory like `/Documents/CSFINE383/workshops`.

2. Use Git to "clone" the workshop repo with this command:
        ```shell
        $ git clone https://username@git.uwaterloo.ca/csfine383/workshops.git .
        ```
        (replace username with your Quest login name, e.g. jdoe)

Now you have a local copy of all the workshop code. As we update the code, you can use `git pull` to get the updated files. If you edit or change code in your local workshops repo directory, then your changes may be lost when you `git pull` a new copy. To avoid this, you can make a copy of the demo code you want to edit somewhere else.

> NOTE: **If you get stuck with using git,** you can also grab the code using the "Download Code" button near the upper right of the project page. But ask us how to get git working, it makes it much easier to get updates and you'll be using git to submit your assignments.

### Note about Markdown files

You'll notice that our code repo has `readme.md` files. These are just text files that can be opened in any text editor. However, these are also special text files that can be rendered with nice looking headings, links, even images. The `md` means "markdown", which is the language used to indicate what's a heading, a bullet, a link, etc. Think of markdown as a really simple format for HTML, that can be easily read as plain text.

If you want to view rendered version of `md` files on your own computer, try [_Markoff_, a free markdown viewer for OSX](https://robots.thoughtbot.com/markoff-free-markdown-previewer).


# Workshop

You'll find all the code for Workshop 0 in the `w0_portrait/` directory. 

## Recorder

The `recorder` sketch is used for recording a sequence of frames to use in your main "portrait" program. It uses the Video library to capture frames.

* Run the sketch and see if your video works. If not, see the comments in the code for ideas for adjustments to make it work.
* Only a 256 by 256 crop of the video is shown and saved. Use the mouse to drag the full frame around to position it.
* Pressing space saves a single frame, hold it down to capture a sequence.
* By default, it only saves up to 30 frames.


## Portrait

The `portrait*` sketches are what you'll use as a starting point. Each loads the frames saved with recorder and then presents the frames in some varied way based on mouse position.


# Exercise

* Modify one of the `portrait` sketches to load and display the frames in a new way. The sketch should use simple mouse movement to make it interactive (just `mouseX` and `mouseY`). 

* Create your own UWaterloo Gitlab project and push your w0 code.

* Generate a GIF animation and share it in the #general channel on the course Teams group. Describe the results of your exercise, including a brief description of what you changed and how your code works.
