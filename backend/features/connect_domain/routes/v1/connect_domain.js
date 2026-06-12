const express = require('express');
const util = require('util');
const { exec, spawn } = require('child_process');
const fs = require('fs/promises');

const Project = require('../../../../common/models/project');

const execAsync = util.promisify(exec);

const customDomainRouter = express.Router();

customDomainRouter.post('/v1/connect-domain', async (req, res) => {
    try {
        let { projectId, domain, subdomain } = req.body;

        // const { stdout, stderr } = await execAsync('curl -s https://api.ipify.org || curl -s ifconfig.me');
        // const publicIp = stdout.trim();

        

        const project = await Project.findById(projectId);
        console.log(project.port);

        let finalDomain = subdomain.trim() === '' ? domain.trim() : `${subdomain.trim()}.${domain.trim()}`;

        await fs.writeFile(
            `/etc/nginx/sites-available/${finalDomain}`,
            generateNginxConfig(finalDomain, project.port, subdomain.trim() !== ''),
            'utf-8'
        );

        await runCommand('sudo', [
            'ln',
            '-sf',
            `/etc/nginx/sites-available/${finalDomain}`,
            `/etc/nginx/sites-enabled/${finalDomain}`,
        ]);

        await runCommand('sudo', ['nginx', '-t']);

        await runCommand('sudo', ['systemctl', 'reload', 'nginx']);

        let certbotArgs = [
            'certbot',
            '--nginx',
            '--register-unsafely-without-email',
            '--agree-tos',
            '-d',
            finalDomain,
        ];
        if (subdomain.trim() === '') {
            certbotArgs.push('-d', `www.${domain.trim()}`);
        }

        await runCommand('sudo', certbotArgs);

        await Project.findByIdAndUpdate(projectId, { domain: domain.trim(), subdomain: subdomain.trim() });

        res.status(201).json({ message: 'Custom domain added successfully', data: { projectId, domain, subdomain } });
    } catch (err) {
        res.status(500).json({ message: err.message });
    }
});

function generateNginxConfig(domain, port, isSubdomainAvailable) {
    const config = `server {
    listen 80;
    server_name <domain>;

    location / {
        proxy_pass http://localhost:<port>;

        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection "upgrade";

        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }
}`;

    return config.replace('<domain>', isSubdomainAvailable ? domain.trim() : `${domain.trim()} www.${domain.trim()}`).replace('<port>', port);
}

function runCommand(command, args) {
    return new Promise((resolve, reject) => {
        const child = spawn(command, args);

        let stdout = '';
        let stderr = '';

        child.stdout.on('data', (data) => {
            stdout += data.toString();
        });

        child.stderr.on('data', (data) => {
            stderr += data.toString();
        });

        child.on('close', (code) => {
            if (code === 0) {
                resolve({ stdout, stderr });
            } else {
                reject(new Error(stderr || `Exited with code ${code}`));
            }
        });
        child.on('error', reject);
    });
}

module.exports = customDomainRouter;
