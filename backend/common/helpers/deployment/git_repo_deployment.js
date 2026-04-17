const { exec, execSync, spawn } = require('child_process');
const fs = require('fs');

const { KAFKA_TOPIC_DEPLOYMENT, KAFKA_DEPLOYMENT_EVENT } = require('../../kafka/kafka_contansts');

const nodeDeployment = require('./framework_deployment/node_deployment');
const dartDeployment = require('./framework_deployment/dart_deployment');

const { clearLogs, logDeployment } = require('../../helpers/log_deployment');
const cloneGitRepo = require('./git_repo_clone');

async function findFramework(projectPath) {
    return new Promise((resolve, reject) => {
        const nixpacksPlan = spawn("nixpacks", ["plan", projectPath]);

        let output = "";
        let errorOutput = "";

        nixpacksPlan.stdout.on("data", (data) => {
            output += data.toString();
        });

        nixpacksPlan.stderr.on("data", (data) => {
            errorOutput += data.toString();
        });

        nixpacksPlan.on("close", (code) => {
            if (code !== 0) {
                return reject(new Error(errorOutput));
            }

            try {
                const plan = JSON.parse(output);

                const framework =
                    plan.variables?.NIXPACKS_METADATA ||
                    plan.providers?.[0] ||
                    "unknown";

                resolve(framework);
            } catch (err) {
                reject(new Error("Invalid JSON from nixpacks"));
            }
        });
    });
}

async function gitRepoDeployment(data, io, projectId, port) {
    try {
        let projectPath = await cloneGitRepo(data, io, projectId, port);

        const framework = await findFramework(projectPath);
        console.log(`Detected Framework: ${framework}`);

        if (framework === 'unknown') {
            logDeployment('\nCould not detect framework');
            io.to(KAFKA_TOPIC_DEPLOYMENT).emit(KAFKA_DEPLOYMENT_EVENT, 'Could not detect framework');
            throw new Error('Could not detect framework');
        } else if (framework === 'node') {
            await nodeDeployment(projectPath, data.repoName, io, projectId, port);
        } else if (framework === 'dart') {
            await dartDeployment(projectPath, data.repoName, io, projectId, port);
        }

        if (fs.existsSync(projectPath)) {
            fs.rmSync(projectPath, { recursive: true, force: true });
        }
    } catch (err) {
        logDeployment('\n' + JSON.stringify(err.message));
        console.error(`gitRepoDeployment Deployment Failed : ${JSON.stringify(err.message)}`);
        throw err;
    }
}

module.exports = gitRepoDeployment;
