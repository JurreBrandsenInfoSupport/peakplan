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

Make sure to use the development container when you run on Windows without using WSL.
For Linux and Mac you can use the approach without development container, but I still 
recommend using the development container.

### Using a development container

In vscode, run the following command: "Dev containers: Clone repository in container volume".
Then enter the URL of the repository: https://github.com/wmeints/peakplan/

The dev container will configure the development environment and restore packages
for the backend and frontend automatically.

### Without a development container

For this approach to work you need to manually install the following:

- [Ruby 3.4.x](https://www.ruby-lang.org/en/downloads/)
- [Node 22.x](https://nodejs.org/en)

After installing Ruby and Node, run the following commands to configure the development environment:

```bash
pushd backend && bundle && popd
pushd frontend && npm install && popd
```

## Running locally

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