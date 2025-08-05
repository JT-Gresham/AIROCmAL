#!/usr/bin/env bash
source /etc/AIROCmAL/AIROCmAL_path
source $AIROCmALdir/libref
source $AIROCmALdir/AIROCmAL_env/bin/activate

curl -sSL https://bootstrap.pypa.io/get-pip.py -o get-pip.py
python get-pip.py