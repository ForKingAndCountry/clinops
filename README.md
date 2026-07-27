# Clinic Management System

A clinic management system (OPD + IPD) for a private clinic in Liberia, designed to run fully OFFLINE on local hardware via Docker, on a local WiFi/LAN network.

## Tech Stack

- **Backend**: PHP, CodeIgniter 4 (MVC, RESTful API)
- **Database**: MySQL 8
- **Cache/Session/Realtime**: Redis
- **Frontend**: Flutter (Web + Mobile builds)
- **Web Server**: Nginx reverse-proxying PHP-FPM
- **Containerization**: Docker Compose

## Quick Start

### Prerequisites

- Docker and Docker Compose installed
- Flutter SDK installed (for frontend development)

### Starting the Backend

1. Start all Docker containers:
```bash
docker compose up -d
```

2. Check container status:
```bash
docker compose ps
```

3. Test the health endpoint:
```bash
curl http://localhost:8080/api/health
```

Expected response:
```json
{
  "status": "ok",
  "message": "Clinic API is running",
  "timestamp": "2024-07-26 00:00:00"
}
```

### Building the Flutter Frontend

#### Web Build (for station terminals)

```bash
cd frontend
flutter build web --dart-define=API_BASE_URL=http://localhost:8080
```

The built files will be in `frontend/build/web/`. These are automatically served by nginx at `http://localhost:8080/web/`.

#### Mobile Build (for bedside IPD workflows)

```bash
cd frontend
flutter build apk --dart-define=API_BASE_URL=http://YOUR_SERVER_IP:80
```

Replace `YOUR_SERVER_IP` with the actual IP address of the server running the Docker containers.

### Accessing the Application

- **Web App**: http://localhost:8080/web/
- **API**: http://localhost:8080/api/
- **Health Check**: http://localhost:8080/api/health

## Development

### Backend Development

The backend code is in the `backend/` directory. The CodeIgniter 4 app is configured to connect to the MySQL and Redis containers via environment variables.

Key files:
- `backend/app/Controllers/` - API controllers
- `backend/app/Models/` - Database models
- `backend/app/Services/` - Business logic layer
- `backend/app/Config/` - Configuration files

### Frontend Development

The Flutter code is in the `frontend/` directory. The app uses Provider for state management and has a dedicated service layer for API calls.

Key files:
- `frontend/lib/screens/` - UI screens
- `frontend/lib/services/` - API client and services
- `frontend/lib/main.dart` - App entry point

## Docker Services

- **nginx**: Reverse proxy serving the Flutter web build and proxying API requests to PHP-FPM
- **php**: PHP-FPM running CodeIgniter 4
- **mysql**: MySQL 8 database with crash-safe InnoDB settings
- **redis**: Redis for caching, sessions, and pub/sub

All services use `restart: unless-stopped` for power reliability.

## Stopping the Application

```bash
docker compose down
```

To also remove the MySQL data volume:
```bash
docker compose down -v
```

## Project Structure

```
.
├── backend/              # CodeIgniter 4 backend
│   ├── app/             # Application code
│   ├── public/          # Web root
│   ├── writable/        # Writable files
│   └── Dockerfile       # PHP container build
├── frontend/            # Flutter frontend
│   ├── lib/             # Dart source code
│   ├── web/             # Web build output
│   └── android/         # Android build config
├── nginx/               # Nginx configuration
│   └── nginx.conf       # Main config
├── mysql/               # MySQL configuration
│   └── my.cnf           # MySQL settings
└── docker-compose.yml   # Container orchestration
```
# clinops
