# Workshop 5: Distributed Systems

We'll explore the idea of a server to communicate with one or more sketches and create a platform for multi-device artworks.

### Goals

* Install Node.js with npm to create a server
* Use websockets to communicate between a p5.js sketch and a server
* Exercises and brainstorming to create related artworks


# Server and Environment Setup 

A server is a program that does things based on requests sent from other programs. Servers often run on computers connected to a network so programs running on other computers, possibly located anywhere in the world, can make requests. 

**Node.js** is just a way to run JavaScript code without a browser or webpage. It's a command line application. It also includes a tool called **npm** (node package manager).  We'll use npm to install packages to create a Node.js server, all written in JavaScript. 

## Install Node.js

[See also Coding Train "2.1 Server-side with Node.js - Working with Data and APIs in JavaScript"](https://youtu.be/wxbQP1LMZsw)

The easiest way to install Node is to download and run an installer from the [Node.js project page](https://nodejs.org/en/). We'll use the latest LTS (long term service) version, which is 16.14.2 at time of writing.

> [This blog](https://www.geeksforgeeks.org/installation-of-node-js-on-windows/) takes you through the installation steps for Windows. MacOS is similar. 

When done installing, open a Terminal and type:

```shell
node -v
```
 
 It should print `v16.14.2` (or whatever the Node.js LTS version was that you installed), then you know Node installed correctly. 
 
 As an extra check, verify that npm is installed correctly, type this:

 ```shell
npm -v
 ```
It should print something like `8.5.5` which is the version of npm that was installed with Node. 




## Create a Node webserver 

In your personal csfine383 repo, create a folder called `server`. 

Open the terminal, and navigate to inside this folder using the `cd` command (on MacOS you can right-click and select "Services/Open Terminal Here"). 

Use npm to "initialize" (init) a new Node project inside this folder using:

```shell
npm init -y
```

This creates a basic `package.json` file in the folder and nothing else.

To create a webserver, we'll use a Node package call "express". Install it by typing:

```shell
npm install express
```

After running the install command, you'll see "express" listed in the project `package.json` and lots of new files in a subfolder called `node_modules/`.

We'll write code to create a Node.js webserver. 

First, create a subfolder called `public/` for html pages to serve. Add a simple `index.html` page for testing like this:

```html
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="utf-8" />
    <title>Server</title>
  </head>
  <body>
    <h1>Hello</h1>
  </body>
</html>
```

In the main `server` folder, add a `server.js` for the Node.js code to create the webserver using the express module:

```js
// import the express package 
const express = require('express');
const app = express();

// start the server on port 3000
const server = app.listen(3000, function() { 
    console.log('http://localhost:3000') 
})

// tell the server to use this subfolder to serve web pages
app.use(express.static('public'));
```

In the Terminal, run the node application to create the server in the Terminal like this:

```shell
node server.js
```

Command-click on the URL in the Terminal (or copy and paste it into your browser), and you should see index.html served from the Node.js webserver.

> You can type Ctrl-C to stop a Node application that's running in the terminal.

# Client-Server Communication 

We'll extend the Node.js webserver built in the last section to communicate with webpages using "sockets" with the [Socket.IO library](https://socket.io/). 

The *client* is a p5.js script running in a browser and the *server* is the Node.js webserver. We can do two-way communication with sockets between client and server, and even broadcast form the server to all clients. 

> Code and steps based on [The Coding Train "12.1: Introduction to Node - WebSockets and p5.js Tutorial"](https://youtu.be/bjULmG8fqc8)

## Incoming Socket Connection on the Server

Install the socket.io library into your Node.js project by typing this (from within the `server/` folder):

```shell
npm install socket.io
```
Now the Socket.IO module is installed in the node project and ready to use. Add this code to `server.js` below the webserver code you wrote in the last section:

```js
// import the socket package too
const socket = require('socket.io')

// create the socket manager
const io = socket(server)

// handle event
io.sockets.on('connection', function (socket) {
    // just log the id of each new connection
    console.log(`connect ${socket.id}`)
})
```

To test if this works, we need a client that will connect to the server. 


## Making a Socket Connection from the Client

The client will be a p5.js sketch. Copy the whole `template/` folder in the root of the workshops repo, and paste it into the `public/` folder in your server project. Rename the folder to `client/`. Now we have a bare bones p5.js sketch to add socket communication capability.

Add the Socket.IO library to the list of includes in `client/index.html`:

```html
<script src="https://cdn.socket.io/4.4.1/socket.io.min.js"></script>
```

In `client/sketch.js`, create a global variable to hold the socket library:

```js
let socket;
```

and make a socket connection to your node server in `setup()`:

```js
socket = io.connect('http://localhost:3000')
```

Start the node application first, then open your client code at: [http://localhost:3000](). You should see a message like this in the terminal:

```shell
http://localhost:3000
connect r1j58NP63slPMUfbAAAB
```

If you refresh the client page, you'll see a new "connect" message since the server thinks this is a new client making the socket connection. 

## Sending Socket Communication from the Client

We'll send mouse x and y positions to the server. To do this, we first put the data we want to send into json, then we send the data to the server along with a meaningful id that describes what data is being sent. In Socket.IO, sending data is called "emitting". 

Add a mouseDragged function to the client sketch with this code:

```js
function mouseDragged() {
  let data = { x: mouseX, y: mouseY }
  socket.emit('mouse', data)
}
```

Here, data is the json data we want to send to the server and "mouse" is the id we chose to describe the data. 

## Receiving Socket Communication on the Server

In `server.js`, add a callback to receive socket communications inside the socket connection callback. 

```js
io.sockets.on('connection', function (socket) {
    console.log(`connect ${socket.id}`)

    // receive socket data with id "mouse"
    socket.on('mouse', function(data) {
        console.log(data)
    })
})
```

Restart the node application and refresh you client page. Drag the mouse and you should see the data sent from the client printed to the Terminal window where the server is running. 

## Broadcasting Socket Communication from the Server

Add a new line to the `socket.on` callback function to "emit" the data from the server back out to other clients.

```js
    socket.on('mouse', function(data) {
        console.log(data)
        socket.broadcast.emit('mouse', data)        
    })
```

This will send the  data out to all clients except the one that sent the original data. 

> See this [Advanced Socket.io tutorial](https://socket.io/get-started/chat) for even more.

## Receiving Socket Communication on the Client


```js
  socket.on('mouse', function(data) {
    print(data)
  })
```

Restart the node application and refresh you client page. Duplicate your client page to make a second client connection. When you drag the mouse in client one, you should see the data printed to the Terminal window where the server is running *and* printed in the console of client two. When you drag the mouse client two, you see the data in the server and in the console of client one. 

## Distributed Drawing

Add p5.js drawing code in the client when data is sent or received.

In the `socket.on` callback in `setup()`:

```js
  socket.on('mouse', function(data) {
    print(data)
    noStroke();
    fill('#00ff00')
    circle(data.x, data.y, 16);
  })
```


In `mouseDragged()`:

```js
function mouseDragged() {
  noStroke()
  fill('#ff0000')
  circle(mouseX, mouseY, 16);

  let data = { x: mouseX, y: mouseY }
  socket.emit('mouse', data)
}
```

## Access the Server on Other Computers

So far, we've been running the Node server only on your local computer. The `http://localhost` URL only works on your machine. 

Depending on the network, it may be possible to connect to a server using the computer's network-assigned IP address. This assumes the network allows communication over the assigned port, and I don't think Eduroam does. 

One solution is to connect each computer to the same router, open the port being used for websocket on the server computer, and then connect to the server computer's IP (usually starts with `192.168`) with the websocket clients.


## Commit your finished Node project to your repo

It's very important "ignore" the directory with all the installed Node packages. The one you generated in the steps above is 6.5 MB with almost 700 files --- and that after installing only two Node packages. Recommended practice is to not commit the `node_packages/` directory to a source code repository. 

This is easily done with a `.gitignore` file. If you don't already have one, create the file in VS Code, add the contents below, and add it to the room of your repository. 

```
.DS_Store

# directories with keys etc.
_private

# node projects
node_modules/
```

Once added, you should see the `node_packages/` directory is grey and when you look at the "Source Control" tab, it won't list all the files in that directory. 


## Initialize an existing Node.js project

You can find the finished code for the steps above in the workshop "w5" repo in the `server/` folder. When you pull it and try to run it, it won't work since (as explained above) recommended practice is to not commit the `node_packages/` directory to a source code repository. 

To initialize an existing Node project you pulled from a repo that doesn't have a `node_packages/`, use this npm command:

```shell
npm install
```
Once executed, you can run the server and clients as explained in the steps above.


# **TODO** Protocols for Specific Communication

## Sketch: **`protocol`**

This demonstrates a simple message protocol where the server looks for a  message from a client which tells it to send a random RGB colour to all clients.

On the client (in `sketch.js`) a socket message is sent whenever the SPACE key is pressed. 

```js


```

On the server (in `server.js`) that message is handled by choosing a random colour and sending it back out to all clients (including the one that sent the message). 

```js


```
    
Each client receives the message and changes the colour.

```js


```

### Exercise

Add a protocol to clear the screen of all clients. 

1. ...


# **TODO** Different *types* of Clients

## Sketch: **`types`**

Client tells server what type they are. 

```js


```

Server puts them in a "room":

```js
// add this socket to a "room"
socket.join('displays');
```

Which is later used to broadcast messages:

```js
// only emit to the "displays" room
io.to('displays').emit('draw', data)
```

### Exercise

Add ...

1. ...
   

# **TODO** Collaborative Drawing Artwork

This is an expanded example using the techniques in the previous section.

Each client has an id that the server keeps track of, and the server keeps track of the mouse state of each client. There are also a number of different visualizations that the server can use.

To try out this pair of sketches, and change the `id` global variable from `1` to a different number in this duplicate. When each client sketch is run, it will show up with the corresponding id in the server sketch's output window.

To achieve this extended functionality, the data structure sent over sockets now has 4 parameters: the client's id, the mouse event type (e.g., moved, pressed), and the `x` and `y` coordinates of the mouse. 

Each client now has an associated `InputState` data structure on the server, which keeps track of the client's mouse position and pressed state.

On the server, we have an `updateClientStates()` function that takes messages off the queue and organizes them into a `HashMap` called `clients`, mapping from client ids as strings, to `InputState`s. A visualization can then iterate through each of the clients in the `HashMap` to draw (or erase) accordingly.

Different visualizations for the server are in  `visualizations.js`. Change the active visualization by replacing the line
```js
let viz = new DrawingViz();
```
with the desired visualization. Each visualization is implemented in a different class, which makes the code more modular and easier to debug and test.

- `DrawingViz`: This is the default visualization. Each client adds to the drawing.
- `CompetitiveDrawingViz`: Each client adds to the drawing, except for one client, chosen at random, who erases instead.
- `PolygonViz`: Each client's mouse position is used as a vertex of a shared polygon.


# Other p5-related things you can do with Node.js

### [**p5-manager**](https://github.com/chiunhau/p5-manager#readme)

A Node.js package that creates a command line tool in your system to create and manage p5.js projects. 

[Coding train video showing](https://youtu.be/LdWleSHQTcw) how to install it and use it. 

### [**p5-node**](https://github.com/andithemudkip/p5-node)

A way to run p5 code as a Node.js application. Could be useful to generate images and easily store them on your computer or serve them as webpages. 


# Exercise for Public Sketchbook

Create a simple, multi-person, mouse-based artwork based on the communication capabilities of the socket code framework. Capture and include a short video of your artwork, and provide a brief (approx. 250 word) description of the artwork and how you use sockets within your artwork.
