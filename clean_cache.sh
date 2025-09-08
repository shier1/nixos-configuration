#!/bin/bash

nix-store --gc
sudo nix-collect-garbage -d
nix-collect-garbage -d
home-manager expire-generations 2
