const express = require('express');
const cors = require('cors');
const mongoose = require('mongoose');

require('dotenv').config();

const app = express();

app.use(cors());
app.use(express.json({ limit: '10mb' }));

const PORT = 5001;

app.get('/', (req, res) => {
  res.send('Hello World!');
});

app.post('/sign-up', (req, res) => {
    res.status(201).json({ message: 'Sign-up successful!' });
});

// Connect MongoDB
// Change mongo to localhost if you want to run it locally without Docker
mongoose.connect("mongodb://mongo:27017/deploystack")
  .then(() => console.log("MongoDB connected"))
  .catch(err => console.log(err));

// Simple Schema
const UserSchema = new mongoose.Schema({
  name: String,
});

const User = mongoose.model("User", UserSchema);

// Routes
app.post("/user", async (req, res) => {
  const user = await User.create({ name: req.body.name });
  res.json(user);
});

app.get("/users", async (req, res) => {
  const users = await User.find();
  res.json(users);
});

app.listen(PORT, () => {
  console.log(`Server is running on port ${PORT}`);
});
