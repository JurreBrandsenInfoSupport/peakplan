#!/bin/bash

. ${NVM_DIR}/nvm.sh && nvm install --lts
pushd /workspaces/peakplan/backend && bundle && popd