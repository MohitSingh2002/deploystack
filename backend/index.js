const express = require('express');
const cors = require('cors');
const mongoose = require('mongoose');
const socketIO = require('socket.io');
const http = require('http');

const connectKafka = require('./common/kafka/connect_kafka');
const consumeKafka = require('./common/kafka/consumer');

require('dotenv').config();

const authRouter = require('./features/auth/routes/v1/auth');
const gitAuthRouter = require('./features/git_auth/routes/v1/git_auth');
const gitAuthenticationRouter = require('./features/git_auth/routes/authentication/git_authentication');
const gitAuthCheckRouter = require('./features/git_auth/routes/authentication/git_auth_check');
const githubRepositoriesRouter = require('./features/github_repositories/routes/v1/github_repositories');
const githubBranchesRouter = require('./features/github_repositories/routes/v1/github_branches');
const deploymentRouter = require('./features/deployment/routes/v1/deployment');

const app = express();
var server = http.createServer(app);
var io = socketIO(server, {
  cors: {
    origin: "*",
  },
  methods: ["GET", "POST"],
});

app.use(cors());
app.use(express.json({ limit: '10mb' }));
app.use('/api', authRouter);
app.use('/api', gitAuthRouter);
app.use(gitAuthenticationRouter);
app.use('/api', gitAuthCheckRouter);
app.use('/api', githubRepositoriesRouter);
app.use('/api', githubBranchesRouter);
app.use('/api', deploymentRouter);

const PORT = 5001;

app.get('/', (req, res) => {
  res.send('DeployStack');
});

// Change mongo to localhost if you want to run it locally without Docker
mongoose.connect("mongodb://localhost:27017/deploystack")
  .then(async () => {
    console.log(`Connected to MongoDB`);

    await connectKafka();

    server.listen(PORT, () => {
        console.log(`Server is running on port ${PORT}`);
    });
  })
  .catch(err => console.log(err));

io.on('connection', (socket) => {
  socket.on('deployment', (data) => {
    socket.join('deployment');
  });
});

consumeKafka(io);
