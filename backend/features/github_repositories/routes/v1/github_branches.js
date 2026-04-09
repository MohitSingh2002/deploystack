const express = require('express');
const axios = require('axios');

const generateGitHubToken = require('../../../../common/helpers/generate_github_token');

const githubBranchesRouter = express.Router();

githubBranchesRouter.get('/v1/github-branches', async (req, res) => {
    try {
        let { owner, repo } = req.query;
        
        let installationToken = await generateGitHubToken();

        const branches = await axios.get(
            `https://api.github.com/repos/${owner}/${repo}/branches?per_page=100&page=1`,
            {
            headers: {
                Authorization: `token ${installationToken}`,
                Accept: 'application/vnd.github+json',
            },
            }
        );

        let data = branches.data.map(r => ({
            name: r.name,
        }));

        res.status(200).json({
            count: data.length,
            branches: data,
        });
    } catch (err) {
        res.status(500).json({ message: err.message });
    }
});

module.exports = githubBranchesRouter;
