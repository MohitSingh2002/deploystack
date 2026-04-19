# DeployStack

![Hero Image placeholder](/docs/assets/hero.png)

DeployStack is a full-stack deployment orchestration platform that seamlessly integrates with GitHub to automatically fetch, deploy, and manage your repositories. It features a responsive Flutter-based frontend for monitoring deployments, a powerful Node.js backend, and relies on MongoDB and Apache Kafka to handle robust asynchronous event messaging.

## 🚀 Features

- **GitHub Integration:** Authorize via GitHub Apps to fetch repositories, setup webhooks, and trigger events on pushes.
- **Automated Deployments:** Trigger project builds and deployments effortlessly using background workers.
- **Asynchronous Architecture:** Uses Apache Kafka to process build triggers and deployment events reliably.
- **Real-time Monitoring:** Keep track of your deployment logs and live project statuses.
- **Containerized:** Fully packaged with Docker for "one-click" local spin-ups and production environments.

## 📸 Screenshots

| Dashboard | Deployment Logs |
|-----------|-----------------|
| ![Dashboard Placeholder](/docs/assets/dashboard.png) | ![Logs Placeholder](/docs/assets/logs.png) |

| Setup Screen | GitHub Integration |
|--------------|---------------------|
| ![Setup Placeholder](/docs/assets/setup.png) | ![GitHub Placeholder](/docs/assets/github.png) |

## 🏗️ Architecture Stack

- **Frontend:** Flutter Web (served via Nginx)
- **Backend:** Node.js (Express.js)
- **Database:** MongoDB 6
- **Event Streaming:** Apache Kafka
- **Orchestration:** Docker & Docker Compose

## 💻 Running Locally

To run this project locally on your machine, you must have [Docker Desktop](https://docs.docker.com/get-docker/) installed and running.

### 1. Clone the repository
```bash
git clone https://github.com/MohitSingh2002/deploystack.git
cd deploystack
```

### 2. Configure Environment Variables
If testing strictly locally, defaults will work, but you can override configurations using `.env` files.

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
# Note: Ensure you set up GitHub App secrets for authentication features
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
2. Ensure you have Git installed, then clone the repository:
```bash
git clone https://github.com/MohitSingh2002/deploystack.git
cd deploystack
```
3. Run the installation script as root:
```bash
sudo ./install.sh
```

**What the script does automatically:**
- Installs Docker, Docker Compose, and Node.js
- Retrieves your server's Public IPv4 address seamlessly.
- Dynamically generates `.env` files for both frontend and backend using your Public IP.
- Starts the `docker-compose` stack natively.
- Assures the required UFW firewall ports (8080 & 5001) are open.

*(Security Note: Sensitive infrastructure ports including MongoDB and Kafka are securely bound to `127.0.0.1` keeping your production data completely inaccessible from the public internet).*

## 🤝 Contributing

Contributions are always welcome! Feel free to open an issue or submit a Pull Request.

## 📄 License

This project is licensed under the MIT License.
