const fs = require('fs');

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

module.exports = { clearLogs, logDeployment };
