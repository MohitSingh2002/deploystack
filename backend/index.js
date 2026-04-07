const express = require('express');
const cors = require('cors');
const mongoose = require('mongoose');

require('dotenv').config();

const authRouter = require('./features/auth/routes/v1/auth');
const gitAuthRouter = require('./features/git_auth/routes/v1/git_auth');
const gitAuthenticationRouter = require('./features/git_auth/routes/authentication/git_authentication');
const gitAuthCheckRouter = require('./features/git_auth/routes/authentication/git_auth_check');

const app = express();

app.use(cors());
app.use(express.json({ limit: '10mb' }));
app.use('/api', authRouter);
app.use('/api', gitAuthRouter);
app.use(gitAuthenticationRouter);
app.use('/api', gitAuthCheckRouter);

const PORT = 5001;

app.get('/', (req, res) => {
  res.send('DeployStack');
});

// Change mongo to localhost if you want to run it locally without Docker
mongoose.connect("mongodb://localhost:27017/deploystack")
  .then(() => {
    console.log(`Connected to MongoDB`);
    app.listen(PORT, () => {
        console.log(`Server is running on port ${PORT}`);
    });

  })
  .catch(err => console.log(err));

// const UserSchema = new mongoose.Schema({
//   name: String,
// });

// const User = mongoose.model("User", UserSchema);

// app.post("/user", async (req, res) => {
//   const user = await User.create({ name: req.body.name });
//   res.json(user);
// });

// app.get("/users", async (req, res) => {
//   const users = await User.find();
//   res.json(users);
// });
