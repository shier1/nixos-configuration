#!/bin/bash

CONFIG_DIR="$HOME/nixos-config"
home-manager switch --flake "$CONFIG_DIR#$(whoami)@$(hostname)" -b backup
