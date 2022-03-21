// import the express package 
const express = require('express');
const app = express();

// start the server on port 3000
const server = app.listen(3000, function() { 
    console.log('http://localhost:3000') 
})

// tell the server to use this subfolder to serve web pages
app.use(express.static('public'));

// import the socket package too
const socket = require('socket.io')

// create the socket manager
const io = socket(server)

let displays = []

// handle event
io.sockets.on('connection', function (socket) {
    console.log(`connect ${socket.id}`)

    socket.on('setup', function(data) {
        console.log(` ${socket.id} setup ${JSON.stringify(data)}`)
        if (data.type == 'display') {
            // add this socket to a "room"
            socket.join('displays');
            console.log(' added to displays')
        } else {
            socket.join('inputs');
        }
    })

    socket.on('draw', function(data) {
        console.log(` ${socket.id} draw ${JSON.stringify(data)}`)

        // only emit to the "displays" room
        io.to('displays').emit('draw', data)

        // send same packet to other clients
        // socket.broadcast.emit('draw', data)
        // this is how to broadcast to all clients
        // io.socket.broadcast.emit('mouse', data)
    })
})