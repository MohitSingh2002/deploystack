const { spawn } = require('child_process');
const Docker = require('dockerode');

// const { getPort } = require('get-port');
// const getPort = require('get-port');

const { KAFKA_TOPIC_DEPLOYMENT, KAFKA_DEPLOYMENT_EVENT } = require('../../../kafka/kafka_contansts');

const { clearLogs, logDeployment } = require('../../../helpers/log_deployment');

const Project = require('../../../models/project');

async function nodeDeployment(targetDir, imageName, io, projectId, port) {
    try {
        await new Promise((resolve) => {
            const stopContainer = spawn('docker', ['rm', '-f', `${imageName}-container`]);

            stopContainer.on('close', () => resolve());
        });

        await new Promise((resolve) => {
            const removeImage = spawn('docker', ['rmi', '-f', imageName]);

            removeImage.on('close', () => resolve());
        });

        const nixpacks = spawn('nixpacks', [
            'build', targetDir,
            '--name', imageName,
            '-e', 'NIXPACKS_NODE_VERSION=20'
        ]);

        nixpacks.stdout.on('data', (data) => {
            logDeployment(data.toString());
            io.to(KAFKA_TOPIC_DEPLOYMENT).emit(KAFKA_DEPLOYMENT_EVENT, data.toString());
        });
        nixpacks.stderr.on('data', (data) => {
            logDeployment(data.toString());
            io.to(KAFKA_TOPIC_DEPLOYMENT).emit(KAFKA_DEPLOYMENT_EVENT, data.toString());
        });

        await new Promise((resolve, reject) => {
            nixpacks.on('close', (code) => code === 0 ? resolve() : reject(new Error(`Nixpacks failed with code ${code}`)));
        });

        const getPort = (await import('get-port')).default;
        const freePort = await getPort();
        const availablePort = port !== '' ? port : freePort;

        const dockerRun = spawn('docker', [
            'run', '-d',
            '--name', `${imageName}-container`,
            '-p', `${availablePort}:3000`,
            imageName
        ]);

        dockerRun.stdout.on('data', (data) => {
            logDeployment(data.toString());
            io.to(KAFKA_TOPIC_DEPLOYMENT).emit(KAFKA_DEPLOYMENT_EVENT, data.toString());
        });
        dockerRun.stderr.on('data', (data) => {
            logDeployment(data.toString());
            io.to(KAFKA_TOPIC_DEPLOYMENT).emit(KAFKA_DEPLOYMENT_EVENT, data.toString());
        });

        await new Promise((resolve, reject) => {
            dockerRun.on('close', (code) => code === 0 ? resolve() : reject(new Error(`Docker run failed with code ${code}`)));
        });

        await Project.findByIdAndUpdate(projectId, { port: availablePort });
        logDeployment(`Container "${imageName}-container" is live at ${availablePort}, use http://<ipv4>:${availablePort}`);
        io.to(KAFKA_TOPIC_DEPLOYMENT).emit(KAFKA_DEPLOYMENT_EVENT, `Container "${imageName}-container" is live at ${availablePort}, use http://<ipv4>:${availablePort}`);
    } catch (err) {
        throw err;
    }
}

module.exports = nodeDeployment;
