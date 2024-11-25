const express = require('express');
const path = require('path');
const http = require('http');
const socketio = require('socket.io');
const PORT = process.env.PORT || 8081; // Use port 8080 for deployment
const app = express();
const server = http.createServer(app);
const io = socketio(server);

// Serve static files from the 'public' folder
app.use(express.static(path.join(__dirname, 'public')));

// Handle the root route and serve a basic HTML message
app.get('/', (req, res) => {
  res.send('Welcome to the Battleship Game!');
});

// Start the server
server.listen(PORT, () => {
  console.log(`Server running on port ${PORT}`);
});

// Socket.io connections
const connections = [null, null];

io.on('connection', socket => {
  // Find an available player number
  let playerIndex = -1;
  for (const i in connections) {
    if (connections[i] === null) {
      playerIndex = i;
      break;
    }
  }

  // Tell the connecting client what player number they are
  socket.emit('player-number', playerIndex);
  console.log(`Player ${playerIndex} has connected`);

  if (playerIndex === -1) return;

  connections[playerIndex] = false;

  // Notify others about the connection
  socket.broadcast.emit('player-connection', playerIndex);

  // Handle disconnects
  socket.on('disconnect', () => {
    console.log(`Player ${playerIndex} has disconnected`);
    connections[playerIndex] = null;
    socket.broadcast.emit('player-connection', playerIndex);
  });
});
