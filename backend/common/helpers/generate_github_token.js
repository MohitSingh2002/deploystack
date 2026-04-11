const jwt = require('jsonwebtoken');
const axios = require('axios');

const User = require('../models/user');
const Git = require('../models/git');

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

async function checkIfInstallationTokenValid(token) {
    try {
        const res = await axios.get(
            `https://api.github.com/installation/repositories`,
            {
                headers: {
                    Authorization: `token ${token}`,
                    Accept: 'application/vnd.github+json',
                },
            }
        );

        return res.status === 200;
    } catch (err) {
        return false;
    }
}

async function generateGitHubToken() {
    const user = await User.findOne().populate('git');
    if (user && user.git && user.git.installationToken) {
        const isTokenValid = await checkIfInstallationTokenValid(user.git.installationToken);
        if (isTokenValid) {
            return user.git.installationToken;
        }
    }

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

    await Git.findOneAndUpdate(
        {},
        { installationToken: installationToken },
        { new: true, upsert: true }
    );

    return installationToken;
}

module.exports = generateGitHubToken;
