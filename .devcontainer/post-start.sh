#!/bin/bash

# Load Node Version Manager and install latest LTS
. ${NVM_DIR}/nvm.sh && nvm install --lts

# Restore packages for backend
pushd /workspace/backend && bundle install && popd

# Restore packages for frontend
pushd /workspace/frontend && npm install --force && popd
