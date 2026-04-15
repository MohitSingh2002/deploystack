const express = require('express');
const zlib = require('zlib');

const ProjectDeploymentLog = require('../../../../common/models/project_deployment_log');

const projectDeploymentLogsRouter = express.Router();

projectDeploymentLogsRouter.get('/v1/project-deployment-logs', async (req, res) => {
    try {
        let projectId = req.query.project;

        const logs = await ProjectDeploymentLog.find({ projectId }).sort({ createdAt: -1 });

        let data = [];
        for (let log of logs) {
            data.push({
                projectId: log.projectId,
                createdAt: log.createdAt,
                log: Buffer.from(zlib.gunzipSync(log.logs).toString(), 'utf-8').toString('base64'),

            });
        }

        res.status(200).json({ count: logs.length, logs: data });
    } catch (err) {
        res.status(500).json({ message: err.message });
    }
});

module.exports = projectDeploymentLogsRouter;
