const fs = require('fs');
const path = require('path');
const { spawn } = require('child_process');

const generateGitHubToken = require('../generate_github_token');

const { KAFKA_TOPIC_DEPLOYMENT, KAFKA_DEPLOYMENT_EVENT } = require('../../kafka/kafka_contansts');

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
      buffers[key] = lines.pop();

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

async function cloneGitRepo(type, data, io, projectId, port) {
    const BASE_DIR = path.join(__dirname, '../../../clone-repos');
    const projectPath = path.join(BASE_DIR, data.repoName);

    if (!fs.existsSync(BASE_DIR)) {
        fs.mkdirSync(BASE_DIR, { recursive: true });
    }

    if (fs.existsSync(projectPath)) {
        fs.rmSync(projectPath, { recursive: true, force: true });
    }

    let cloneUrl = data.cloneUrl;

    if (type === 'git-repo-deployment') {
      let installationToken = await generateGitHubToken();

      cloneUrl = cloneUrl.replace(
          'https://',
          `https://x-access-token:${installationToken}@`
      );
    }

    await cloneRepo(
        'git',
        type === 'git-deployment' ? ['clone', '--progress', cloneUrl, projectPath] : ['clone', '--progress', '-b', data.name, cloneUrl, projectPath],
        (log) => {
            logDeployment(log);
            io.to(KAFKA_TOPIC_DEPLOYMENT).emit(KAFKA_DEPLOYMENT_EVENT, log);
        }
    );

    return projectPath;
}

module.exports = cloneGitRepo;
