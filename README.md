# Peakplan - Sample application

[![Frontend Tests](https://github.com/wmeints/peakplan/actions/workflows/frontend-tests.yml/badge.svg)](https://github.com/wmeints/peakplan/actions/workflows/frontend-tests.yml)
[![Backend Tests](https://github.com/wmeints/peakplan/actions/workflows/backend-tests.yml/badge.svg)](https://github.com/wmeints/peakplan/actions/workflows/backend-tests.yml)


I use this application to test out how we can use AI agents to convert codebases from one language to another.
Please follow the instructions below to edit the code in this repository.

## Features

- Manage your daily tasks
- Manage your long-term projects
- Get automatic reminders in via e-mail

## Development setup

You have three options for running the application:

### Option 1: Using Docker Compose (Recommended)

The easiest way to run the application is with Docker Compose. This requires only Docker Desktop.

**Prerequisites:**
- [Docker Desktop](https://www.docker.com/products/docker-desktop/)

**Quick Start:**

```bash
# Start all services (database, backend, frontend)
docker-compose up -d

# View logs
docker-compose logs -f

# Stop all services
docker-compose down
```

The application will be available at:
- Frontend: http://localhost:4200
- Backend API: http://localhost:3000

See [DOCKER_README.md](DOCKER_README.md) for detailed Docker documentation.

### Option 2: Using a development container

In vscode, run the following command: "Dev containers: Clone repository in container volume".
Then enter the URL of the repository: https://github.com/wmeints/peakplan/

The dev container will configure the development environment and restore packages
for the backend and frontend automatically.

### Option 3: Running locally without containers

For this approach to work you need to manually install the following:

- [Ruby 3.4.x](https://www.ruby-lang.org/en/downloads/)
- [Node 22.x](https://nodejs.org/en)
- [PostgreSQL 16.x](https://www.postgresql.org/download/)

After installing the prerequisites, run the following commands to configure the development environment:

```bash
pushd backend && bundle && popd
pushd frontend && npm install && popd
```

## Running locally

### With Docker Compose

```bash
docker-compose up -d
```

### Without Docker

To run the backend, use the following command:

```bash
cd backend
rails db:migrate
bin/dev
```

You can run the frontend with the following command:

```bash
cd frontend && npm run dev
```

The frontend automatically proxies to the backend.

## Documentation

Please refer to the README files in the backend and frontend directory to learn more
about testing and modifying code.