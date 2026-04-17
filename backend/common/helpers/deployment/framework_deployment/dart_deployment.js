const fs = require("fs");
const path = require("path");
const { spawn } = require('child_process');
const tar = require("tar-fs");
const Docker = require("dockerode");

const docker = new Docker();

const { KAFKA_TOPIC_DEPLOYMENT, KAFKA_DEPLOYMENT_EVENT } = require('../../../kafka/kafka_contansts');

const { clearLogs, logDeployment } = require('../../../helpers/log_deployment');

const Project = require('../../../models/project');

async function dartDeployment(projectPath, imageName, io, projectId, port) {
    try {
        const dockerfileContent = `# Stage 1: Build
FROM ghcr.io/cirruslabs/flutter:stable AS builder

WORKDIR /app
COPY . .

RUN flutter pub get
RUN flutter build web --release

FROM nginx:alpine

COPY --from=builder /app/build/web /usr/share/nginx/html

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]`;

        const dockerfilePath = path.join(projectPath, "Dockerfile");
        fs.writeFileSync(dockerfilePath, dockerfileContent, "utf-8");

        await new Promise((resolve) => {
            const stopContainer = spawn('docker', ['rm', '-f', `${imageName}-container`]);

            stopContainer.on('close', () => resolve());
        });

        await new Promise((resolve) => {
            const removeImage = spawn('docker', ['rmi', '-f', imageName]);

            removeImage.on('close', () => resolve());
        });

        const tarStream = tar.pack(projectPath);

        await new Promise((resolve, reject) => {
            docker.buildImage(tarStream, { t: imageName }, (err, stream) => {
                if (err) return reject(err);

                stream.on("data", (chunk) => {
                    const lines = chunk.toString("utf8").split("\n").filter(Boolean);

                    lines.forEach((line) => {
                        try {
                            const json = JSON.parse(line);

                            if (json.stream) {
                                logDeployment(json.stream);
                                io.to(KAFKA_TOPIC_DEPLOYMENT).emit(KAFKA_DEPLOYMENT_EVENT, json.stream);
                            }

                            if (json.status) {
                                const msg = `${json.status} ${json.progress || ""}\n`;
                                logDeployment(msg);
                                io.to(KAFKA_TOPIC_DEPLOYMENT).emit(KAFKA_DEPLOYMENT_EVENT, msg);
                            }

                            if (json.error) {
                                logDeployment(`${json.error}\n`);
                                io.to(KAFKA_TOPIC_DEPLOYMENT).emit(KAFKA_DEPLOYMENT_EVENT, `${json.error}\n`);
                                return reject(new Error(json.error));
                            }

                        } catch {
                            logDeployment(`${line}\n`);
                            io.to(KAFKA_TOPIC_DEPLOYMENT).emit(KAFKA_DEPLOYMENT_EVENT, `${line}\n`);
                        }
                    });
                });

                stream.on("end", resolve);
                stream.on("error", reject);
            });
        });

        const getPort = (await import('get-port')).default;
        const freePort = await getPort();
        const availablePort = port !== '' ? port : freePort;

        const container = await docker.createContainer({
            name: `${imageName}-container`,
            Image: imageName,
            ExposedPorts: { "80/tcp": {} },
            HostConfig: {
                PortBindings: {
                    "80/tcp": [{ HostPort: `${availablePort}` }],
                },
            },
        });

        await container.start();

        spawn('docker', ['image', 'prune', '-f']);

        await Project.findByIdAndUpdate(projectId, { port: availablePort });
        logDeployment(`Container "${imageName}-container" is live at ${availablePort}, use http://<ipv4>:${availablePort}`);
        io.to(KAFKA_TOPIC_DEPLOYMENT).emit(KAFKA_DEPLOYMENT_EVENT, `Container "${imageName}-container" is live at ${availablePort}, use http://<ipv4>:${availablePort}`);
    } catch (err) {
        throw err;
    }
}

module.exports = dartDeployment;
