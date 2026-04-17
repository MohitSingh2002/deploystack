const express = require('express');

const deploymentRouter = express.Router();

const productDeploymentEvent = require('../../../../common/kafka/producer');

const Project = require('../../../../common/models/project');
const GitHubProject = require('../../models/git_hub_project');

deploymentRouter.post('/v1/deploy-git-hub-repo', async (req, res) => {
    let event = {
        'type': 'git-repo-deployment',
        'data': req.body
    };

    const existingGitHubProject = await GitHubProject.findOne({
        repoName: req.body.repoName,
        branchName: req.body.name
    });

    if (existingGitHubProject) {
        const existingProject = await Project.findOne({
            gitHubProject: existingGitHubProject._id
        });

        event.projectId = existingProject._id;
        event = {...event, projectId: existingProject._id, port: existingProject.port};
    } else {
        const gitHubProject = new GitHubProject({
            fullName: req.body.fullName,
            cloneUrl: req.body.cloneUrl,
            ownerName: req.body.ownerName,
            repoName: req.body.repoName,
            branchName: req.body.name
        });
        
        await gitHubProject.save();

        const project = new Project({
            name: req.body.repoName,
            type: 'git-repo-deployment',
            gitHubProject: gitHubProject._id
        });

        await project.save();

        event = {...event, projectId: project._id, port: project.port};
    }

    await productDeploymentEvent(event);
    res.status(201).json({ message: 'Deployment Initiated' });
});

module.exports = deploymentRouter;
