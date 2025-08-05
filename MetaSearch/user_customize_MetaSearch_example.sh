#!/usr/bin/env bash
source AIROCmAL/libref
####  This file is for you to add any code you want to execute just before MetaSearch launches.  This will not be updated when AIROCmAL or MetaSearch updates.
####  This is useful if you want to create custom presets and make sure your code, links, etc gets put back after an official update from the MetaSearch team.
####  I'll include the code I wrote to load my own custom preset as an example.  I didn't wnat to do this every time the MetaSearch team updated...

####  THIS CODE STARTS IN YOUR PARENT DIRECTORY
####    eg: where the AIROCmAL directory is located

#### EXAMPLE CODE ####

#  Change directory to make things easier
#cd $pdirectory/AIROCmAL

#  Copy files (without overwritting) from my custom preset directory (MetaSearch_Presets) I created in the AIROCmAL shared folder
#cp --no-clobber -R shared/presets/MetaSearch/* MetaSearch/presets/

#  Change into the MetaSearch directory for the next part.
#cd MetaSearch/modules

#  Since my name is both capital letters, I need to make a change into a MetaSearch file so it will recognize my name as "JT" ...not "Jt" (only if needed)
#    Coding note: The \x27 that you see everywhere is an ASCII escape...necessary for sed to process strings with single quotes in them.

#  if grep -Fxq "k = k.replace('Jt', 'JT')" sdxl_styles.py
#    then
#      echo "JT correction entry found in sdxl_styles.py...skipping"
#    else
#      sed -i 's|k = k.replace(\x27(s\x27, \x27(S\x27)|k = k.replace(\x27(s\x27, \x27(S\x27)\n    k = k.replace(\x27Jt\x27, \x27JT\x27)|g' sdxl_styles.py
#  fi

#  Lastly, I want MetaSearch to make sure to add my styles only if needed...the 'if' statement makes sure there isn't duplicate lines of code added. 
#  if grep -Fxq "sdxl_styles_JT.json" sdxl_styles.py
#    then
#      echo "JT styles entry found in sdxl_styles.py...skipping"
#    else
#      sed -i 's|\x27sdxl_styles_sai.json\x27,|\x27sdxl_styles_sai.json\x27,\n          \x27sdxl_styles_JT.json\x27,|g' sdxl_styles.py
#  fi
