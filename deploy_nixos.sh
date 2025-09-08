#!/bin/bash

CONFIG_DIR="$HOME/nixos-config"
sudo nixos-rebuild switch --flake "$CONFIG_DIR#$(hostname)"
