# DeployStack

<a href="https://www.producthunt.com/products/deploystack-2?embed=true&amp;utm_source=badge-featured&amp;utm_medium=badge&amp;utm_campaign=badge-deploystack-2" target="_blank" rel="noopener noreferrer"><img alt="DeployStack - Open-source, self-hosted alternative to Vercel and Render | Product Hunt" width="250" height="54" src="https://api.producthunt.com/widgets/embed-image/v1/featured.svg?post_id=1127320&amp;theme=light&amp;t=1777185215657"></a>

DeployStack is a full-stack deployment orchestration platform that seamlessly integrates with GitHub to automatically fetch, deploy, and manage your repositories. It features a responsive Flutter-based frontend for monitoring deployments, a powerful Node.js backend, and relies on MongoDB and Apache Kafka to handle robust asynchronous event messaging.

## 🚀 Features

- **GitHub Integration:** Authorize via GitHub Apps to fetch repositories, setup webhooks, and seamlessly link your codebases. Uses GitHub's App Manifest flow so no manual app registration is needed.
- **Public Git URL Deployment:** Deploy any publicly accessible Git repository by providing its clone URL — no GitHub account required.
- **Continuous Deployment (CI/CD):** Deploy a repository by specifying a target branch. Every time you push a newly crafted commit to that branch, DeployStack instantly rebuilds the project and pushes the updates live in real-time!
- **Framework Auto-Detection:** Automatically detects the project framework using Nixpacks and deploys accordingly — supports **Node.js** (via Nixpacks buildpacks) and **Flutter Web / Dart** (via Dockerfile + `flutter build web`). No Dockerfile needed from the user.
- **Custom Domains with Auto SSL:** Attach a custom domain or subdomain to any deployed project. DeployStack automatically configures Nginx as a reverse proxy and provisions a Let's Encrypt SSL certificate via Certbot.
- **Asynchronous Architecture:** Uses Apache Kafka (KRaft mode, no ZooKeeper) to process build triggers and deployment events securely and reliably.
- **Real-time Streaming Logs:** Live deployment logs are streamed to the dashboard via Socket.IO as they happen.
- **Persistent Deployment History:** Every deployment log is gzip-compressed and stored in MongoDB. Review historical logs for any project at any time.
- **Project Management:** View all your deployed projects, their assigned ports, and access logs from a single dashboard.
- **Containerized:** Fully packaged with Docker for "one-click" local spin-ups and production environments. Each deployment runs in its own isolated Docker container.

## 📸 Screenshots

| Dashboard | Setup Screen |
|-----------|-----------------|
| ![Dashboard](screenshots/dashboard_screen.png) | ![Setup Screen](screenshots/setup_screen.png) |

| Deployments | Projects Page |
|--------------|---------------------|
| ![Deployments](screenshots/deployment.png) | ![Projects Page](screenshots/projects_screen.png) |

| Deployment Logs | Custom Domain |
|-----------------|--------------|
| ![Deployment Logs](screenshots/deployment_logs.png) | ![Custom Domain](screenshots/custom_domain.png) |

## 🏗️ Architecture Stack

- **Frontend:** Flutter Web (served via Nginx) — uses `flutter_bloc` for state management, `go_router` for navigation, and Clean Architecture with `get_it` DI.
- **Backend:** Node.js (Express.js v5, Mongoose v9, Socket.IO v2) — REST API + WebSocket for real-time streaming.
- **Database:** MongoDB 6
- **Event Streaming:** Apache Kafka (KRaft mode, no ZooKeeper)
- **Build System:** Nixpacks (auto-detects framework, builds Docker images without a Dockerfile)
- **Orchestration:** Docker & Docker Compose (sibling containers per deployment via Docker socket)

## 💻 Running Locally

To run this project locally on your machine, you must have [Docker Desktop](https://docs.docker.com/get-docker/) installed and running.

### 1. Clone the repository
```bash
git clone https://github.com/MohitSingh2002/deploystack.git
cd deploystack
```

### 2. Configure Environment Variables
If testing strictly locally, defaults will work, but you can override configurations using `.env` files.

**Root Configuration (Database):**
Create a `.env` file in the root directory to specify your secure MongoDB password for Docker Compose (if omitted, it defaults to `local_dev_password_123` for local testing).
```bash
# .env
MONGO_DB_PASSWORD=your_secure_password_here
```

**Frontend Configuration:**
Create a `.env` file inside the `frontend/` directory to point to your backend API host (defaults to `http://localhost:5001`).
```bash
# frontend/.env
API_HOST=http://localhost:5001
```

**Backend Configuration:**
Create a `.env` file inside the `backend/` directory.
```bash
# backend/.env
FRONTEND_URL=http://localhost:8080
MONGO_URI=mongodb://admin:local_dev_password_123@mongo:27017/deploystack?authSource=admin
```

### 3. Spin up the Containers
Run Docker Compose to build and start the entire stack:
```bash
docker compose up -d --build
```
> **Note:** The initial build may take some time depending on your internet speed, as it needs to download the Flutter SDK, build the web app, and pull the images for Kafka and MongoDB.

### 4. Access the Application
- **Frontend Dashboard:** [http://localhost:8080](http://localhost:8080)
- **Backend API:** [http://localhost:5001](http://localhost:5001)

*(To stop the stack, run `docker compose down`)*

## 🚢 Deploying to a VPS

DeployStack includes a powerful, automated `install.sh` script to set up everything on a fresh Ubuntu VPS in practically zero steps. 

1. SSH into your VPS.
2. Run the installation script as root:
```bash
curl -fsSL https://raw.githubusercontent.com/MohitSingh2002/deploystack/main/install.sh | sudo bash
```

**What the script does automatically:**
- Installs Docker, Docker Compose, and Node.js
- Retrieves your server's Public IPv4 address seamlessly.
- Generates a **highly secure, cryptographically random password** for your MongoDB instance so no credentials are ever hardcoded in your repository.
- Dynamically generates `.env` files for the frontend, backend, and Docker compose stack using your Public IP and new secure password.
- Starts the `docker-compose` stack natively.
- Assures the required UFW firewall ports (8080 & 5001) are open.

*(Security Note: Sensitive infrastructure ports including MongoDB and Kafka are securely bound to `127.0.0.1` and password-protected, keeping your production data completely inaccessible from the public internet and automated botnet attacks).*

## 🤝 Contributing

Contributions are always welcome! Feel free to open an issue or submit a Pull Request.
