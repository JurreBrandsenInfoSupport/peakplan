#!/bin/bash

# Load the node version manager scripts automatically
. ${NVM_DIR}/nvm.sh && nvm install --lts

# Restore the packages
pushd /workspaces/peakplan/backend && bundle && popd
pushd /workspaces/peakplan/frontend && npm install --force && popd