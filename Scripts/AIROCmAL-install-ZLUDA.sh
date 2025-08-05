#!/usr/bin/env bash

source /etc/AIROCmAL/AIROCmAL_path
source $AIROCmALdir/libref
source $AIROCmALdir/AIROCmAL_env/bin/activate

sudo pacman -S --needed cargo-run-bin cargo-release
cd $AIROCmALdir/AIROCmAL_env/lib/python3.11/site-packages
git clone --recursive https://github.com/vosen/ZLUDA.git
cd ZLUDA
cargo xtask --release


