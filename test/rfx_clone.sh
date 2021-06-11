#!/usr/bin/env bash

# rfx_clone.sh
# - A utility to quickly clone a specific commit of the RFX repo.
# - Hopefully makes it easier to reproduce bugs and failing tests.
# 
# Workflow:
#     > #
#     > # download the clone script
#     > wget https://raw.githubusercontent.com/andyl/rfx/master/test/rfx_clone.sh
#     > chmod a+rx ./rfx_clone.sh
#     > #
#     > # run the clone script
#     > ./rfx_clone.sh <SHA>
#     > #
#     > # run the failing test
#     > cd rfx
#     > mix test test/edit/credo/multi_alias_test.exs:48   # fill in your own path...
# 
# Notes:
# - this is only tested on Ubuntu 20.04
# - it might work on Mac
# - it will fail on Windows
# - please file issues and/or submit PRs if you find bugs in this script!
#

abort_argv() {
  echo "Usage: rfx_clone.sh <SHA>"
  echo "rfx_clone.sh - clone and setup the RFX repo"
  echo "visit https://github.com/andyl/rfx for more info"
  exit 1
}

abort_directory() {
  echo "Error: directory 'rfx' already exists."
  echo "Please remove the directory and try again..."
  exit 1
}

[[ $# == 0 ]] && abort_argv
[[ -d "./rfx" ]] && abort_directory

SHA=$1

clone_rfx() {
  echo "----- Clone RFX"
  git clone https://github.com/andyl/rfx.git
}

checkout_sha() {
  echo "----- Checkout SHA $SHA"
  cd rfx
  git checkout $SHA
}

get_deps() {
  echo "----- Get project dependencies"
  mix deps.get
}

run_tests() {
  echo "----- Run tests"
  mix test --exclude pending
}

clone_rfx && checkout_sha && get_deps && run_tests && echo "----- DONE"

