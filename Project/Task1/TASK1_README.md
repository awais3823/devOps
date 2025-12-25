# Task 1: Dockerize Final Year Project Application
### 1. Check Docker Installation
# Verify Docker is installed
docker --version

### 2. Navigate to Project Directory
cd "C:\Users\GHALI\OneDrive - Higher Education Commission\8th semester\devops\ABB\devOps\Project\nginx-nodejs-redis"

### 3. Build and Start All Containers
# Build images and start all services in detached mode
docker compose up -d
### 4. Check Container Status
# View all running containers
docker compose ps

**Expected Output:**
NAME       IMAGE                      STATUS                    PORTS
nginx-lb   nginx-nodejs-redis-nginx   Up X minutes             0.0.0.0:8080->80/tcp
redis-db   redis:7-alpine             Up X minutes             0.0.0.0:6379->6379/tcp
web1       nginx-nodejs-redis-web1    Up X minutes (healthy)   0.0.0.0:81->5000/tcp
web2       nginx-nodejs-redis-web2    Up X minutes (healthy)   0.0.0.0:82->5000/tcp


### 5. View Container Logs

# View logs for all services
docker compose logs

# View logs for specific service
docker compose logs web1
docker compose logs web2
docker compose logs nginx
docker compose logs redis

# Follow logs in real-time
docker compose logs -f


### 6. Stop Containers
# Stop all containers (keeps data)
docker compose stop

# Stop and remove containers
docker compose down

# Stop and remove containers, volumes, and networks
docker compose down -v

### 7. Rebuild After Code Changes
# Rebuild and restart containers
docker compose up -d --build
### 1. Verify All Containers Are Running
docker compose ps
# Connect to Redis container
docker compose exec redis redis-cli ping

# Check Redis data
docker compose exec redis redis-cli get numVisits

**Expected Output:** `PONG` for ping, visit count number for get

### 5. Verify Frontend in Browser
1. Open browser and navigate to: `http://localhost:8080`
2. You should see:
   - A modern web interface with visit counter
   - Server hostname displayed (web1 or web2)
   - Visit count incrementing
   - Auto-refresh every 5 seconds

### 6. Verify Network Connectivity
# Check Docker network
docker network ls

# Inspect the application network
docker network inspect nginx-nodejs-redis_app-network

# Verify Container Health
# Check container health status
docker compose ps

### Check Container Logs for Errors
# View recent logs
docker compose logs --tail=50

# View logs with timestamps
docker compose logs -t

# View logs for specific service
docker compose logs web1 --tail=20

### Check Container Resource Usage
# View resource usage
docker stats

# View specific container stats
docker stats nginx-nodejs-redis-web1-1
# Quick Start Commands Summary 
# 1. Start the application
docker compose up -d

# 2. Check status
docker compose ps

# 3. View logs
docker compose logs -f
# To verify spp on browser 
`http://localhost:8080`

# 5. Stop application
docker compose down

