const express = require('express');

const deploymentRouter = express.Router();

const productDeploymentEvent = require('../../../../common/kafka/producer');

const Project = require('../../../../common/models/project');
const GitHubProject = require('../../models/git_hub_project');
const GitProject = require('../../models/git_project');

deploymentRouter.post('/v1/deploy-git-hub-repo', async (req, res) => {
    req.body.repoName = req.body.repoName.toLowerCase();

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

function extractRepoName(input) {
  if (!input || typeof input !== "string") return null;

  input = input.trim();

  // Case 1: gh repo clone user/repo
  if (input.startsWith("gh repo clone")) {
    const parts = input.split(" ");
    const repoPath = parts[3]; // jrgarciadev/nextjs-todo-list
    if (!repoPath) return null;
    return repoPath.split("/").pop();
  }

  // Case 2: git@github.com:user/repo.git
  if (input.startsWith("git@")) {
    const repoPath = input.split(":")[1]; // user/repo.git
    if (!repoPath) return null;
    return repoPath.replace(".git", "").split("/").pop();
  }

  // Case 3: https://github.com/user/repo.git
  if (input.startsWith("http")) {
    try {
      const url = new URL(input);
      const parts = url.pathname.split("/").filter(Boolean); // ["user","repo.git"]
      return parts.pop().replace(".git", "");
    } catch {
      return null;
    }
  }

  return null;
}

deploymentRouter.post('/v1/deploy-git-repo', async (req, res) => {
    let event = {
        'type': 'git-deployment',
        'data': {
            'repoName': extractRepoName(req.body.cloneUrl).toLowerCase(),
            'cloneUrl': req.body.cloneUrl
        }
    }

    const existingGitProject = await GitProject.findOne({
        cloneUrl: req.body.cloneUrl
    });

    if (existingGitProject) {
        const existingProject = await Project.findOne({
            gitProject: existingGitProject._id
        });

        event.projectId = existingProject._id;
        event = {...event, projectId: existingProject._id, port: existingProject.port};
    } else {
        const gitProject = new GitProject({
            cloneUrl: req.body.cloneUrl,
        });

        await gitProject.save();

        const project = new Project({
            name: event.data.repoName,
            type: 'git-deployment',
            gitProject: gitProject._id
        });

        await project.save();

        event = {...event, projectId: project._id, port: project.port};
    }

    await productDeploymentEvent(event);
    res.status(201).json({ message: 'Deployment Initiated' });
});

module.exports = deploymentRouter;
