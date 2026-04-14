const express = require('express');

const deploymentRouter = express.Router();

const productDeploymentEvent = require('../../../../common/kafka/producer');

deploymentRouter.post('/v1/deploy-git-hub-repo', async (req, res) => {
    const event = {
        'type': 'git-repo-deployment',
        'data': req.body
    };
    await productDeploymentEvent(event);
    res.status(201).json({ message: 'Deployment Initiated' });
});

module.exports = deploymentRouter;
