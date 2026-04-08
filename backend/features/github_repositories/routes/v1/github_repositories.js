const express = require('express');
const jwt = require('jsonwebtoken');
const axios = require('axios');

const User = require('../../../../common/models/user');

const githubRepositoriesRouter = express.Router();

function generateJWT(appId, privateKey) {
  const payload = {
    iat: Math.floor(Date.now() / 1000) - 60,
    exp: Math.floor(Date.now() / 1000) + (10 * 60),
    iss: appId,
  };

  if (privateKey.includes('\\n')) {
    privateKey = privateKey.replace(/\\n/g, '\n');
  }

  return jwt.sign(payload, privateKey, { algorithm: 'RS256' });
}

githubRepositoriesRouter.get('/v1/github-repositories', async (req, res) => {
    try {
        const user = await User.findOne().populate('git');
        const token = generateJWT(user.git.id, user.git.pem);

        const installations = await axios.get('https://api.github.com/app/installations', {
            headers: {
                Authorization: `Bearer ${token}`,
                Accept: 'application/vnd.github+json',
            },
        });

        if (installations.data.length === 0) {
            return res.status(500).json({ message: 'No installations found' });
        }

        const installationId = installations.data[0].id;

        const authResponse = await axios.post(
            `https://api.github.com/app/installations/${installationId}/access_tokens`,
            {},
            {
                headers: {
                Authorization: `Bearer ${token}`,
                Accept: 'application/vnd.github+json',
                },
            }
        );

        const installationToken = authResponse.data.token;

        let allRepos = [];
        let page = 1;

        while (true) {
            const repos = await axios.get(
                `https://api.github.com/installation/repositories?per_page=100&page=${page}`,
                {
                headers: {
                    Authorization: `token ${installationToken}`,
                    Accept: 'application/vnd.github+json',
                },
                }
            );

            allRepos.push(...repos.data.repositories);

            if (repos.data.repositories.length < 100) break;

            page++;
        }

        let data = allRepos.map(r => ({
            full_name: r.full_name,
            clone_url: r.clone_url,
        }));

        res.status(200).json({
            count: data.length,
            repositories: data,
        });
    } catch (err) {
        res.status(500).json({ message: err.message });
    }
});

module.exports = githubRepositoriesRouter;
