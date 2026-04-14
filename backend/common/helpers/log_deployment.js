const fs = require('fs');
const zlib = require('zlib');
const ProjectDeploymentLog = require('../models/project_deployment_log');

const logFile = "deployment.log";

let logStream = fs.createWriteStream(logFile, { flags: 'a' });

function clearLogs() {
    if (logStream) {
        logStream.end();
    }

    if (fs.existsSync(logFile)) {
        fs.unlinkSync(logFile);
    }

    fs.writeFileSync(logFile, '');

    logStream = fs.createWriteStream(logFile, { flags: 'a' });
}

function logDeployment(message) {
    logStream.write(message);
}

async function saveLogs(projectId) {
    if (!fs.existsSync(logFile)) return;

    let logs = fs.readFileSync(logFile, 'utf-8');

    const compressedLogs = zlib.gzipSync(logs);

    const projectDeploymentLog = new ProjectDeploymentLog({
        projectId : projectId,
        logs: compressedLogs
    });
    await projectDeploymentLog.save();
}

module.exports = { clearLogs, logDeployment, saveLogs };
