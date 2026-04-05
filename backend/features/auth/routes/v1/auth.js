const express = require('express');
const jwt = require('jsonwebtoken');
const User = require('../../models/user');

const authRouter = express.Router();

authRouter.post('/v1/sign-up', async (req, res) => {
    try {
        const { name } = req.body;
        let user = await User.findOne({ name: name });
        if (!user) {
            user = await User.create({ name: name });
        }

        res.status(201).json({ user });

        // const token = jwt.sign({ id: user._id }, 'DeployStackPasswordKey');

        // res.status(201).json({ user, token });
    } catch (err) {
        res.status(500).json({ message: err.message });
    }
});

authRouter.get('/v1/get-user', async (req, res) => {
    try {
        const user = await User.findOne();

        if (!user) {
            res.status(500).json({ message: 'No user found' });
            return;
        }

        res.status(200).json({ name: user.name });
    } catch (err) {
        res.status(500).json({ message: err.message });
    }
});

module.exports = authRouter;
