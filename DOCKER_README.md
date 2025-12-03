# Dockerization: HAProxy Load Balancer

This document explains the Docker setup for the HAProxy Load Balancer, which acts as the entry point for the system.

## 🐳 Dockerfile Overview

The Dockerfile builds a custom HAProxy image with SSL termination and monitoring enabled.

### Key Features
- **Base Image:** `haproxy:lts`
- **SSL Termination:** Decrypts HTTPS traffic at the load balancer level using `haproxy.pem` (combined cert + key).
- **Load Balancing:** Routes traffic to Backend, Frontend, and Keycloak servers based on URL paths.
- **Monitoring:** Enables a stats dashboard on port **8404**.

## 🛠️ Build & Run Commands

### 1. Build the Image
Run this from the `Vm-Haproxy` directory:

```bash
docker build -t my-haproxy .
```

### 2. Run the Container
We expose port **443** for traffic and **8404** for monitoring.

```bash
docker run -d -p 443:443  -p 8404:8404  --name haproxy  my-haproxy
```

### 3. Access Monitoring
Open your browser and navigate to:
`http://<VM_IP>:8404/stats`
(User/Pass configured in `haproxy.cfg`, e.g., `admin` / `ChamadaQR@2024!`)

## 📂 Configuration (`haproxy.cfg`)
The configuration defines:
- **Frontend `https_front`**: Listens on 443, handles SSL.
- **Backends**:
  - `frontend_servers`: Angular VM
  - `backend_servers`: Spring VM
  - `keycloak_server`: Keycloak VM
- **Stats**: Monitoring page configuration.

## 🔑 SSL Configuration
The Dockerfile automatically combines `ssl_certs/fullchain.pem` and `ssl_certs/wildcard.key` into a single `/etc/haproxy/certs/haproxy.pem` file required by HAProxy.
