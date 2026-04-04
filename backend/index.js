const express = require('express');
const cors = require('cors');

require('dotenv').config();

const app = express();

app.use(cors());
app.use(express.json({ limit: '10mb' }));

const PORT = process.env.PORT || 5001;

app.get('/', (req, res) => {
  res.send('Hello World!');
});

app.post('/sign-up', (req, res) => {
    res.status(201).json({ message: 'Sign-up successful!' });
});

app.listen(PORT, () => {
  console.log(`Server is running on port ${PORT}`);
});
