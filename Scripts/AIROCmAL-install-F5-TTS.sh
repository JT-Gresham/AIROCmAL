#!/usr/bin/env bash

source /etc/AIROCmAL/AIROCmAL_path
source $AIROCmALdir/libref
source $AIROCmALdir/AIROCmAL_env/bin/activate
aiinaalpkg="F5-TTS"
aiinaalpkgURL="https://github.com/PasiKoodaa/F5-TTS.git"

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
rm -r /tmp/$aiinaalpkg
source $AIROCmALdir/$aiinaalpkg/libref-$aiinaalpkg
echo ""
echo "Applying AIROCmAL modifications to original $aiinaalpkg..."
AIROCmAL_update_$aiinaalpkg
cp $AIROCmALdir/$aiinaalpkg/user_customize_$aiinaalpkg_example.sh $AIROCmALdir/$aiinaalpkg/user_customize_$aiinaalpkg.sh
echo ""
echo "Installing packages from requirements_versions.txt..."
cd $AIROCmALdir/$aiinaalpkg
pip install -e .
sleep 1
#pip install -r requirements_versions.txt
pip install -r requirements_$aiinaalpkg.txt
echo ""
echo "Creating the launcher file ($aiinaalpkg-Start.sh)"
cp "user_customize_"$aiinaalpkg"_example.sh" "user_customize_"$aiinaalpkg".sh"
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
echo "python $AIROCmALdir/$aiinaalpkg/app_local.py \"\$@\"" >> $AIROCmALdir/$aiinaalpkg/$aiinaalpkg-Start.sh
#echo "sleep 60"
#echo "echo "F5-TTS is still running in the background. Enter command: F5-TTS-exit to close down F5-TTS.""
#echo "" >> $AIROCmALdir/$aiinaalpkg/$aiinaalpkg-Start.sh
echo "Setting the new start file to be executable. (Authorization Required)"
sudo chmod +x $AIROCmALdir/$aiinaalpkg/$aiinaalpkg-Start.sh
echo "Creating executable link in /usr/bin --> AIROCmAL-$aiinaalpkg"
sudo ln -sf "$AIROCmALdir/$aiinaalpkg/$aiinaalpkg-Start.sh" "/usr/bin/AIROCmAL-$aiinaalpkg"
echo "Installation complete. Start with command: AIROCmAL-$aiinaalpkg with any F5-TTS arguments afterward"
echo "--Press any key to exit installer--"
read go
exit 0
