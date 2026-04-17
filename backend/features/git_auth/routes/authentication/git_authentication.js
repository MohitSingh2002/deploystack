const express = require('express');
const axios = require('axios');
const User = require('../../../../common/models/user');
const Git = require('../../../../common/models/git');

const GitHubProject = require('../../../deployment/models/git_hub_project');
const Project = require('../../../../common/models/project');

const productDeploymentEvent = require('../../../../common/kafka/producer');

const gitAuthenticationRouter = express.Router();

gitAuthenticationRouter.get("/github/callback", async (req, res) => {
  const code = req.query.code;

  if (!code) {
    return res.send("No code received from GitHub");
  }

  try {
    const response = await axios.post(
      `https://api.github.com/app-manifests/${code}/conversions`,
      {},
      {
        headers: {
          Accept: "application/vnd.github+json"
        }
      }
    );

    const data = response.data;

    let githubData = {
        id: data.id,
        name: data.name,
        slug: data.slug,
        webhookSecret: data.webhook_secret,
        pem: data.pem
    };

    const git = await Git.create(githubData);

    await User.findOneAndUpdate(
        {},
        { git: git._id },
        { new: true, upsert: true }
    );

    return res.redirect(`https://github.com/apps/${data.slug}/installations/new`);
  } catch (error) {
    console.error(error.response?.data || error.message);
    res.send("Error creating GitHub App");
  }
});

// Optional: Setup route
gitAuthenticationRouter.get("/setup", async (req, res) => {
//   res.send("⚙️ Setup page after installation");

    const installationId = req.query.installation_id;

    await Git.findOneAndUpdate(
        {},
        { installationId: installationId },
        { new: true, upsert: true }
    );

    return res.redirect('http://localhost:8080/');
});

// Optional: Webhook receiver
gitAuthenticationRouter.post("/webhook", express.json(), async (req, res) => {
  let repository = req.body.repository;
  
  let data = {
    fullName: repository.full_name,
    cloneUrl: repository.clone_url,
    ownerName: repository.owner.name,
    repoName: repository.name,
    name: req.body.ref.replace('refs/heads/', ''),
    createdAt: new Date().toString()
  };

  let event = {
      'type': 'git-repo-deployment',
      'data': data
  };

  const existingGitHubProject = await GitHubProject.findOne({
    repoName: data.repoName,
    branchName: data.name
  });

  if (existingGitHubProject) {
    const existingProject = await Project.findOne({
      gitHubProject: existingGitHubProject._id
    });

    event.projectId = existingProject._id;
    event = {...event, projectId: existingProject._id, port: existingProject.port};
  }

  await productDeploymentEvent(event);

  res.sendStatus(200);
});

module.exports = gitAuthenticationRouter;
