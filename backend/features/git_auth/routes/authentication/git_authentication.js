const express = require('express');
const axios = require('axios');
const User = require('../../../../common/models/user');
const Git = require('../../../../common/models/git');

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

    return res.redirect('http://localhost:60501/');
});

// Optional: Webhook receiver
gitAuthenticationRouter.post("/webhook", express.json(), (req, res) => {
//   console.log("📩 Webhook received:", req.body);
  res.sendStatus(200);
});

module.exports = gitAuthenticationRouter;
