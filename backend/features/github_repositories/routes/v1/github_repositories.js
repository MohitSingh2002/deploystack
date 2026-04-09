const express = require('express');
const axios = require('axios');

const generateGitHubToken = require('../../../../common/helpers/generate_github_token');

const githubRepositoriesRouter = express.Router();

githubRepositoriesRouter.get('/v1/github-repositories', async (req, res) => {
    try {
        let installationToken = await generateGitHubToken();

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
            owner_name: r.owner.login,
            repo_name: r.name,
            default_branch: r.default_branch,
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
