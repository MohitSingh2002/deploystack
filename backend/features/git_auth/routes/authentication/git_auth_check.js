const express = require('express');
const User = require('../../../../common/models/user');

const gitAuthCheckRouter = express.Router();

gitAuthCheckRouter.get('/check-app', async (req, res) => {
    try {
        let user = await User.findOne().populate('git');

        if (user && user.git && user.git.installationId && user.git.installationId !== '') {
            res.status(200).json({ isInstalled: true });
        } else {
            res.status(200).json({ isInstalled: false });
        }
    } catch (err) {
        res.status(500).json({ message: err.message });
    }
});

module.exports = gitAuthCheckRouter;
