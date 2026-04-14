const { spawn } = require('child_process');
const Docker = require('dockerode');

// const { getPort } = require('get-port');
// const getPort = require('get-port');

const { KAFKA_TOPIC_DEPLOYMENT, KAFKA_DEPLOYMENT_EVENT } = require('../../../kafka/kafka_contansts');

const { clearLogs, logDeployment } = require('../../../helpers/log_deployment');

async function nodeDeployment(targetDir, imageName, io) {
    try {
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

        const dockerRun = spawn('docker', [
            'run', '-d',
            '--name', `${imageName}-container`,
            '-p', `${freePort}:3000`,
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

        logDeployment(`Container "${imageName}-container" is live at ${freePort}, use http://<ipv4>:${freePort}`);
        io.to(KAFKA_TOPIC_DEPLOYMENT).emit(KAFKA_DEPLOYMENT_EVENT, `Container "${imageName}-container" is live at ${freePort}, use http://<ipv4>:${freePort}`);
    } catch (err) {
        throw err;
    }
}

module.exports = nodeDeployment;
