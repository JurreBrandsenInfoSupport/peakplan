# Docker Setup for Peakplan

This directory contains Docker Compose configuration to run the Peakplan application with frontend, backend, and database services.

## Prerequisites

- Docker Desktop installed and running
- Git (for cloning the repository)

## Services

The docker-compose setup includes three services:

- **database**: PostgreSQL 16 database
- **backend**: Ruby on Rails API (port 3000)
- **frontend**: Next.js application (port 4200)

## Quick Start

1. Start all services:
```bash
docker-compose up -d
```

2. View logs:
```bash
docker-compose logs -f
```

3. Access the application:
   - Frontend: http://localhost:4200
   - Backend API: http://localhost:3000

4. Stop all services:
```bash
docker-compose down
```

## Development

The setup includes volume mounts for both frontend and backend code, so changes you make to the source code will be reflected in the running containers.

### Backend

- Code changes are automatically reloaded by Rails
- Database migrations run automatically on startup
- Logs: `docker-compose logs backend`

### Frontend

- Hot reload is enabled via Next.js Turbopack
- Logs: `docker-compose logs frontend`

### Database

- Data is persisted in a Docker volume (`peakplan_postgres_data`)
- To reset the database: `docker-compose down -v` (this removes all data)

## Troubleshooting

### Backend container keeps restarting

The backend automatically fixes line endings on startup (Windows compatibility). If issues persist, check the logs:
```bash
docker-compose logs backend
```

### Port already in use

If you see "port already allocated" errors, stop any local instances of the application running outside Docker:
```bash
# Stop all containers
docker-compose down

# Check what's using the ports
netstat -ano | findstr :3000
netstat -ano | findstr :4200
```

### Database connection issues

Make sure the database container is healthy:
```bash
docker-compose ps
```

The backend waits for the database to be healthy before starting.

## Rebuilding

If you need to rebuild the images after changing Dockerfile or dependencies:

```bash
docker-compose up --build
```

## Clean Start

To start fresh with clean databases and rebuilt images:

```bash
docker-compose down -v
docker-compose up --build
```
