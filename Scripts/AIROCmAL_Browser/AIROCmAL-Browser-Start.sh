#!/usr/bin/env bash

source /etc/AIROCmAL/AIROCmAL_path

source $AIROCmALdir/AIROCmAL_env/bin/activate
cd $AIROCmALdir/Scripts/AIROCmAL_Browser

python main.py "$@"
