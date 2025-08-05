#!/usr/bin/env bash
source /etc/AIROCmAL/AIROCmAL_path
AIROCmALuser="$(whoami)"

echo "##### AIROCmAL installation of EXO #####"
cd $AIROCmALdir
echo ""
if [ ! -d "$pdirectory/AIROCmAL/AIROCmAL12_env" ]; then
echo "Creating python 3.12 environment (AIROCmAL12_env)"
/usr/bin/python3.12 -m venv $pdirectory/AIROCmAL/AIROCmAL12_env
echo ""
echo "Activating environment -> AIROCmAL12_env"
source $pdirectory/AIROCmAL/AIROCmAL12_env/bin/activate
echo "AIROCmAL installer needs to check/install some PACMAN packages...Please authorize to continue..."
sudo pacman -S --needed intel-compute-runtime intel-graphics-compiler ocl-icd opencl-headers level-zero-loader python-pipx lm_sensors
echo "Installing pip..."
cd $pdirectory/AIROCmAL/Scripts
python get-pip.py
cd $pdirectory/AIROCmAL
echo ""
echo "Installing wheel package..."
pip install wheel
fi
ln -sf $pdirectory/AIROCmAL/Scripts/ipex-llm-init $pdirectory/AIROCmAL/AIROCmAL12_env/bin/
#ln -sf $pdirectory/AIROCmAL/Scripts/ipex-llm-init $pdirectory/AIROCmAL/AIROCmAL12_env_inf/bin/
echo ""
echo "Initializing the AIROCmAL and Deb4AIROCmAL(12) commands."
ln -sf $pdirectory/AIROCmAL/Scripts/AIROCmAL $pdirectory/AIROCmAL/AIROCmAL12_env/bin/AIROCmAL
ln -sf $pdirectory/AIROCmAL/Scripts/Deb4AIROCmAL12 $pdirectory/AIROCmAL/AIROCmAL12_env/bin/Deb4AIROCmAL12
#sudo ln -sf $pdirectory/AIROCmAL/AIROCmAL12_env/bin/AIROCmAL /bin/AIROCmAL
sudo ln -sf $pdirectory/AIROCmAL/AIROCmAL12_env/bin/Deb4AIROCmAL12 /bin/Deb4AIROCmAL12
#sudo chmod +x /bin/AIROCmAL
sudo chmod +x $pdirectory/AIROCmAL/AIROCmAL12_env/bin/AIROCmAL
sudo chmod +x $pdirectory/AIROCmAL/AIROCmAL12_env/bin/Deb4AIROCmAL12
echo "Creating initial \"shared\" directory...replace with yours afterward, if necssary (symlink allowed)"
if [ ! -d "$pdirectory/AIROCmAL/shared" ]; then
  mv ./shared1 ./shared
fi
cd $tmp
git clone https://github.com/exo-explore/exo.git /tmp/Exo
cp -rf /tmp/Exo/.* /home/LACII14/Archive-M1/AI/AIROCmAL/Exo/
cp -rf /tmp/Exo/* /home/LACII14/Archive-M1/AI/AIROCmAL/Exo/
rm -r /tmp/Exo
cd $AIROCmALdir/Exo
pip install -e .
echo "AIROCmAL framework is now installed. AI program installers are located in the \"Scripts\" directory."
echo "AIROCmAL is updated \(if necessary\) whenever a framework program is started, however..."
echo "   you can also use the command: \"AIROCmAL-update\" in your terminal to update AIROCmAL whenever you wish."
echo ""
echo "Thank you for trying out AIROCmAL...this is a lot of work."
echo ""
echo "Before you press a key to exit the installer, a small request:"
echo "   I'd appreciate it if you'd consider supporting my work by using one of the methods listed on the main github page. - OCD"
read go
#Run after git pull
