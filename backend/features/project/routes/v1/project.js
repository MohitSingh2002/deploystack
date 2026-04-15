const express = require('express');

const Project = require('../../../../common/models/project');

const projectRouter = express.Router();

projectRouter.get('/v1/projects', async (req, res) => {
    try {
        let projectList = await Project.find().sort({ createdAt: -1 }).populate('gitHubProject');

        res.status(200).json({ count: projectList.length, projects: projectList });
    } catch (err) {
        res.status(500).json({ message: err.message });
    }
});

module.exports = projectRouter;
