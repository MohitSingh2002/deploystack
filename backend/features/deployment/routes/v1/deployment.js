const express = require('express');

const deploymentRouter = express.Router();

const productDeploymentEvent = require('../../../../common/kafka/producer');

const Project = require('../../../../common/models/project');
const GitHubProject = require('../../models/git_hub_project');

/**
 * const zlib = require('zlib');

function readLogsFromDB(record) {
    const decompressed = zlib.gunzipSync(record.logs);
    return decompressed.toString();
}
 */

deploymentRouter.post('/v1/deploy-git-hub-repo', async (req, res) => {
    let event = {
        'type': 'git-repo-deployment',
        'data': req.body
    };

    const existingProject = await Project.findOne({
        type: 'git-repo-deployment'
    }).populate({
        path: 'gitHubProject',
        match: { repoName: req.body.repoName }
    });

    if (existingProject && existingProject.gitHubProject) {
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
