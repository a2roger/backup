# Workshop 5: Distributed Systems

We'll explore the idea of connecting multiple sketches together and create a platform for mouse-based multi-person performance art.


## Goals

* Learn about client-server networking with simple websockets
* Brainstorm related art works


# Pre-workshop Set Up

Complete the following _before_ the workshop class.

#### 1. Install required libraries

* [**Websockets**](https://github.com/alexandrainst/processing_websockets), a very simple websocket implementation for Processing.

> Use the menu `Sketch/Import Library.../Add Library...`, in the dialogue that opens, search for the library name and click "Install". 

> Post to Slack if you have trouble with set up. Please provide details so we can diagnose (e.g. operating system, error messages, steps to reproduce the error) 


# In-Class Workshop

During the workshop, we'll review the different Processing code examples and do small exercises.

## Java Socket Communication

### Sketches: **`wsserver1`** and  **`wsclient1`**

You must run server before client, otherwise the client has nothing to connect to, and the sketch will crash. The client will also crash if you stop the server before stopping the client.

Notes:
* websockets
* sending and receiving messages
* creating a simple message protocol
* `ConcurrentLinkedQueue` to reliably transfer data from the websocket thread to the drawing thread.

#### Experiment

Try running two clients and see what happens. To do this, you'll have to duplicate the `wsclient1` script so you can run two clients. 

#### Exercise

The example above demonstrates sending message from the client to the server, but can send messages both ways! Let's create a server message to the client to send a random RGB colour whenever a key is pressed in the server sketch. Use that colour to change the client's drawing colour.

1. In the server's `keyPressed` event function, change the string in the `sendMessage` method to be three comma-delimited numbers for an RGB colour. (Hint: look at `mouseDragged` in the client to format the string.)
2. Parse this RGB colour message in the client's `webSocketEvent`, and use the three numbers to set a global fill color variable to be used by the client. (Hint: look at the `Message` constructor in the server for parsing technique.)


### Sketches: **`wsserver2`** and  **`wsclient2`**

Notes:
* expanded protocol to add id and event for client messages
* HashMap on server to track state of each client
* InputState class in server to store client state

#### Experiments

We'll setup a local network and try to all connect and draw at the same time.

#### Visualization

We'll go through the different visualizations.

* good code practices: using classes for different visualizations

## (EXTRA) Node.js and P5.js Socket Communication: **`nodep5`**

Daniel Shiffman has a [series of short tutorial videos](https://youtu.be/bjULmG8fqc8) explaining how to use sockets with Node.js and P5.js. 

Other related references:

https://github.com/antiboredom/websocket-p5

https://github.com/processing/p5.js/wiki/p5.js,-node.js,-socket.io

# Digital Sketchbook Exercise

Work with a partner to brainstorm a multi-person, mouse-based performance based on the communication capabilities of the socket code framework. Think of a simple idea, if time allows, we'll try and implement it together.










 




