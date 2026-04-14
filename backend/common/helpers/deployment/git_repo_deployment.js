const { exec, execSync, spawn } = require('child_process');
const fs = require('fs');
const path = require('path');

const { KAFKA_TOPIC_DEPLOYMENT, KAFKA_DEPLOYMENT_EVENT } = require('../../kafka/kafka_contansts');

const generateGitHubToken = require('../generate_github_token');
const nodeDeployment = require('./framework_deployment/node_deployment');

const { clearLogs, logDeployment } = require('../../helpers/log_deployment');

function cleanLog(log) {
  return log
    .replace(/\r/g, '\n') // 👈 key fix
    .replace(/\x1b\[[0-9;]*m/g, '')
    .trim();
}

function cloneRepo(command, args, onLog) {
  return new Promise((resolve, reject) => {
    const process = spawn(command, args);

    const buffers = {
      stdout: '',
      stderr: ''
    };

    const handleData = (data, key) => {
      buffers[key] += data.toString();

      const lines = buffers[key].split('\n');
      buffers[key] = lines.pop(); // keep incomplete

      for (const line of lines) {
        const cleaned = cleanLog(line);
        if (cleaned) onLog?.(cleaned);
      }
    };

    process.stdout.on('data', (data) => {
      handleData(data, 'stdout');
    });

    process.stderr.on('data', (data) => {
      handleData(data, 'stderr');
    });

    process.on('close', (code) => {
      if (code === 0) resolve();
      else reject(new Error(`Process exited with code ${code}`));
    });
  });
}

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

async function gitRepoDeployment(data, io) {
    try {
        const BASE_DIR = path.join(__dirname, '../../../clone-repos');
        const projectPath = path.join(BASE_DIR, data.repoName);

        let installationToken = await generateGitHubToken();

        if (!fs.existsSync(BASE_DIR)) {
            fs.mkdirSync(BASE_DIR, { recursive: true });
        }

        if (fs.existsSync(projectPath)) {
            fs.rmSync(projectPath, { recursive: true, force: true });
        }

        let cloneUrl = data.cloneUrl.replace(
            'https://',
            `https://x-access-token:${installationToken}@`
        );

        await cloneRepo(
            'git',
            ['clone', '--progress', '-b', data.name, cloneUrl, projectPath],
            (log) => {
                logDeployment(log);
                io.to(KAFKA_TOPIC_DEPLOYMENT).emit(KAFKA_DEPLOYMENT_EVENT, log);
            }
        );

        const framework = await findFramework(projectPath);
        console.log(`Detected Framework: ${framework}`);

        if (framework === 'unknown') {
            logDeployment('\nCould not detect framework');
            io.to(KAFKA_TOPIC_DEPLOYMENT).emit(KAFKA_DEPLOYMENT_EVENT, 'Could not detect framework');
            throw new Error('Could not detect framework');
        } else if (framework === 'node') {
            await nodeDeployment(projectPath, data.repoName, io);
        }
    } catch (err) {
        logDeployment('\n' + JSON.stringify(err.message));
        console.error(`gitRepoDeployment Deployment Failed : ${JSON.stringify(err.message)}`);
        throw err;
    }
}

module.exports = gitRepoDeployment;
