#!/usr/bin/env bash

source /etc/AIROCmAL/AIROCmAL_path
aiinaalpkg=Auto1111
####  This file is for you to add any code you want to execute just before Auto1111 launches.  This will not be updated when AIROCmAL or Auto1111 updates.
####  This is useful if you want to create custom presets and make sure your code, links, etc gets put back after an official update from the Auto1111 team.
####  I'll include the code I wrote to load my own custom preset as an example.  I didn't wnat to do this every time the Auto1111 team updated...

####  THIS CODE STARTS IN YOUR PARENT DIRECTORY
####    eg: where the AIROCmAL directory is located

#### EXAMPLE CODE ####

# This links Auto1111 to the shared wildcards directory. Enable this after installing the sd-dynamic-prompts extension.
#rm -rf "$AIROCmALdir/$aiinaalpkg/extensions/sd-dynamic-prompts/wildcards"
#ln -sf "$AIROCmALdir/shared/wildcards/Fooocus/" "$AIROCmALdir/$aiinaalpkg/extensions/sd-dynamic-prompts/wildcards"
