#!/usr/bin/env bash

source /etc/AIROCmAL/AIROCmAL_path
source $AIROCmALdir/libref
source $AIROCmALdir/AIROCmAL_env/bin/activate
aiinaalpkg="SwarmUI"
aiinaalpkgURL="https://github.com/mcmonkeyprojects//$aiinaalpkg.git"

echo "########## $aiinaalpkg for Intel Arc GPUs on Arch Linux ##########"
echo "##################### framework by JT Gresham #####################"
echo ""
echo "*     This installer requires that you have up-to-date drivers for your Intel Arc GPU."
echo "*     This installer requires that you have the AIROCmAL already installed."
echo "*     This installer will create a customized start script by using the information you enter."
echo ""
echo "Press enter to continue the installation..."
read go
echo "Your installation will be installed in $AIROCmALdir/$aiinaalpkg"
echo ""
AIROCmAL_update
echo "Changing directory ->$AIROCmALdir/$aiinaalpkg"
cd $AIROCmALdir/$aiinaalpkg
echo ""
echo "Cloning official $aiinaalpkg repository to $aiinaalpkg"

#### GIT CLONE COMMAND  URL HERE ####
git clone "$aiinaalpkgURL" "/tmp/$aiinaalpkg"
mv -f "/tmp/$aiinaalpkg/.git" "$AIROCmALdir/$aiinaalpkg/"
mv -rf "/tmp/$aiinaalpkg/sdxl_styles/"* "$AIROCmALdir/shared1/sdxl_styles/"
cd $AIROCmALdir/$aiinaalpkg
git checkout .
mkdir "$AIROCmALdir/$aiinaalpkg/models"
rm -r /tmp/$aiinaalpkg
source $AIROCmALdir/$aiinaalpkg/libref-$aiinaalpkg
echo ""
echo "Applying AIROCmAL modifications to original $aiinaalpkg..."
AIROCmAL_update_$aiinaalpkg
cp $AIROCmALdir/$aiinaalpkg/user_customize_$aiinaalpkg_example.sh $AIROCmALdir/$aiinaalpkg/user_customize_$aiinaalpkg.sh
echo ""
echo "Installing packages from requirements_versions.txt..."
cd $AIROCmALdir/$aiinaalpkg
sleep 1
#pip install -r requirements_versions.txt
pip install -r requirements_$aiinaalpkg.txt
ln -sf "$AIROCmALdir/AIROCmAL_env/lib/python3.11/dotnetcore2/bin/dotnet" "$AIROCmALdir/AIROCmAL_env/bin/dotnet"
cd launchtools
rm dotnet-install.sh
wget https://dot.net/v1/dotnet-install.sh -O dotnet-install.sh
chmod +x dotnet-install.sh
cd ..
SCRIPT_DIR=$(echo $AIROCmALdir/$aiinaalpkg)
# Note: manual installers that want to avoid home dir, add to both of the below lines: --install-dir "$AIROCmALdir/$aiinaalpkg/.dotnet"
./launchtools/dotnet-install.sh --channel 8.0 --runtime aspnetcore --install-dir "$AIROCmALdir/$aiinaalpkg/.dotnet"
./launchtools/dotnet-install.sh --channel 8.0 --install-dir "$AIROCmALdir/$aiinaalpkg/.dotnet"

echo ""
echo "Creating the launcher file ($aiinaalpkg-Start.sh)"
cp user_customize_$aiinaalpkg_example.sh user_customize_$aiinaalpkg.sh
touch $AIROCmALdir/$aiinaalpkg/$aiinaalpkg-Start.sh
echo "#!/usr/bin/env bash" > $AIROCmALdir/$aiinaalpkg/$aiinaalpkg-Start.sh
echo "" >> $AIROCmALdir/$aiinaalpkg/$aiinaalpkg-Start.sh
echo "source /etc/AIROCmAL/AIROCmAL_path" >> $AIROCmALdir/$aiinaalpkg/$aiinaalpkg-Start.sh
echo "source $AIROCmALdir/libref" >> $AIROCmALdir/$aiinaalpkg/$aiinaalpkg-Start.sh
echo "source $AIROCmALdir/$aiinaalpkg/libref-$aiinaalpkg" >> $AIROCmALdir/$aiinaalpkg/$aiinaalpkg-Start.sh
echo "source $AIROCmALdir/AIROCmAL_env/bin/activate" >> $AIROCmALdir/$aiinaalpkg/$aiinaalpkg-Start.sh
echo "AIROCmAL_update" >> $AIROCmALdir/$aiinaalpkg/$aiinaalpkg-Start.sh

#### Executable below
echo "source ipex-llm-init -g --device Arc" >> $AIROCmALdir/$aiinaalpkg/$aiinaalpkg-Start.sh
echo "AIROCmAL_update_$aiinaalpkg" >> $AIROCmALdir/$aiinaalpkg/$aiinaalpkg-Start.sh
echo "cd $AIROCmALdir/$aiinaalpkg" >> $AIROCmALdir/$aiinaalpkg/$aiinaalpkg-Start.sh
echo "$AIROCmALdir/$aiinaalpkg/launch-linux.sh \"\$@\"" >> $AIROCmALdir/$aiinaalpkg/$aiinaalpkg-Start.sh
#echo "sleep 60"
#echo "echo "SwarmUI is still running in the background. Enter command: SwarmUI-exit to close down SwarmUI.""
#echo "" >> $AIROCmALdir/$aiinaalpkg/$aiinaalpkg-Start.sh
echo "Setting the new start file to be executable. (Authorization Required)"
sudo chmod +x $AIROCmALdir/$aiinaalpkg/$aiinaalpkg-Start.sh
echo "Creating executable link in /usr/bin --> AIROCmAL-$aiinaalpkg"
sudo ln -sf "$AIROCmALdir/$aiinaalpkg/$aiinaalpkg-Start.sh" "/usr/bin/AIROCmAL-$aiinaalpkg"
mkdir "$AIROCmALdir/$aiinaalpkg/src/bin"
touch "$AIROCmALdir/$aiinaalpkg/src/bin/last_build"
if grep -Fxq "https://pytorch-extension.intel.com/release-whl/stable/xpu/us" $AIROCmALdir/$aiinaalpkg/launchtools/comfy-install-linux.sh
    then
        echo "JT correction entry found in sdxl_styles.py...skipping"
    else
        sed -i 's|--extra-index-url https://download.pytorch.org/whl/cu124|--extra-index-url https://pytorch-extension.intel.com/release-whl/stable/xpu/us|g' $AIROCmALdir/$aiinaalpkg/launchtools/comfy-install-linux.sh
        sed -i 's|--index-url https://download.pytorch.org/whl/rocm6.1|--extra-index-url https://pytorch-extension.intel.com/release-whl/stable/xpu/us|g' $AIROCmALdir/$aiinaalpkg/launchtools/comfy-install-linux.sh
fi
echo "Installation complete. Start with command: AIROCmAL-$aiinaalpkg with any SwarmUI arguments afterward"
echo "     IMPORTANT: To use SwarmUI with the ComfyUI backend if already installed in AIROCmAL:"
echo "          1.) You need to tell SwarmUI you have a pre-existing installation...so make that choice upon first startup"
echo "          2.) If you've already downloaded models, you won't need to install any...not even the base one so deselect all of them"
echo "          3.) Once you can get to the server settings, you need to set the ComfyUI backend launcher to your ComfyUI-Start.sh file in your AIROCmAL/ComfyUI directory.  The easiest way is to copy the file address in your file browser and then paste it into you launcher entry."
echo "That's it...SwarmUI should launch and autostart your ComfyUI installation. It may complain because it's looking for main.py...but pay no attention to that warning.  Your AIROCmAL launcher will handle that after the settings/mods are handled."
echo "##### DON'T set it to the main.py file it's asking for...seriously...doing that can mess stuff up. #####"
echo "--Press any key to exit installer--"
read go
exit 0
