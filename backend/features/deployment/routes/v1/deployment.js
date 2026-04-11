const express = require('express');

const deploymentRouter = express.Router();

const productDeploymentEvent = require('../../../../common/kafka/producer');

/**
 * {
    * "fullName":"MohitSingh2002/OpenSoftwares",
    * "cloneUrl":"https://github.com/MohitSingh2002/OpenSoftwares.git",
    * "ownerName":"MohitSingh2002",
    * "repoName":"OpenSoftwares",
    * "name":"master"
 * }
 */

deploymentRouter.post('/v1/deploy-git-hub-repo', async (req, res) => {
    const event = {
        'type': 'git-repo-deployment',
        'data': req.body
    };
    await productDeploymentEvent(event);
    res.status(201).json({ message: 'Deployment initiated' });
});

module.exports = deploymentRouter;
