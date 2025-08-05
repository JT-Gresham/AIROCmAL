#!/usr/bin/env bash
AIROCmALuser="$(whoami)"

echo "########## AI Framework for Intel Arc GPUs on Arch Linux ##########"
echo "################### created by JT Gresham ####################"
echo ""
echo "*  This installer requires that you have up-to-date drivers for your Intel Arc GPU."
echo "*  You also need to have Python 3.11 installed since this installer creates your"
echo "       python virtual environment with it. It can be found in the AUR (python311)"
echo "*  This installer will check/install a couple of packages via PACMAN. These are installed"
echo "       from the offical Arch repositories so you will be asked to authorize the install with"
echo "       your password."
echo "*  Installing this framework will provide a more efficient installation of popular AI packages."
echo "   This installation will create custom launchers by using the information you enter here."
echo ""
echo "Press enter to continue the installation..."
read go
echo "AIROCmAL installer needs to check/install some PACMAN packages...Please authorize to continue..."
sudo pacman -S --needed intel-compute-runtime intel-graphics-compiler ocl-icd opencl-headers level-zero-loader wget git python-pipx 
echo ""
echo "--- Important Notes:"
echo "   * This directory can get pretty big in size as you add AI Software, LLMs, Checkpoints...etc!"
echo "   * Make sure you've got storage space to accomodate your future needs!"
echo "   * To avoid potential issues, the FULL PATH should not contain any spaces or special characters."
echo ""
echo "What is the FULL PATH of directory where you want to install \"AIROCmAL\"?"
echo "---IMPORTANT: Exclude the trailing \"/\"---"
read pdirectory
echo ""
echo "Your installation will be installed in $pdirectory/AIROCmAL"
echo ""
echo "Changing directory -> $pdirectory"
cd $pdirectory
echo ""
echo "Creating the AIROCmAL-update command..."
echo "#!/usr/bin/env bash" > /usr/bin/AIROCmAL-update
echo "" >> /usr/bin/AIROCmAL-update
echo "source $pdirectory/AIROCmAL_env/bin/activate" >> /usr/bin/AIROCmAL-update
echo "souce $pdirectory/AIROCmAL/libref" >> /usr/bin/AIROCmAL-update
echo "AIROCmAL_update" >> /usr/bin/AIROCmAL-update
sudo chmod +x /usr/bin/AIROCmAL-update
git clone https://github.com/JT-Gresham/AIROCmAL.git
echo ""
cd $pdirectory/AIROCmAL/Scripts
sudo mkdir /etc/AIROCmAL
sudo touch /etc/AIROCmAL/AIROCmAL_path
sudo chmod 777 /etc/AIROCmAL/AIROCmAL_path
echo "#!/usr/bin/env bash" > /etc/AIROCmAL/AIROCmAL_path
echo "" > /etc/AIROCmAL/AIROCmAL_path
echo "pdirectory=$pdirectory" > /etc/AIROCmAL/AIROCmAL_path
echo "AIROCmALdir=$pdirectory/AIROCmAL" >> /etc/AIROCmAL/AIROCmAL_path
source /etc/AIROCmAL/AIROCmAL_path
bash $pdirectory/AIROCmAL/Scripts/librefgen
echo "Changing directory ->$pdirectory/AIROCmAL"
cd $pdirectory/AIROCmAL
echo ""
echo "Creating python 3.11 environment (AIROCmAL_env)"
/usr/bin/python3.11 -m venv $pdirectory/AIROCmAL/AIROCmAL_env
#echo "Creating python 3.11 environment (AIROCmAL_env_inf)"
#/usr/bin/python3.11 -m venv $pdirectory/AIROCmAL/AIROCmAL_env_inf
echo ""
echo "Activating environment -> AIROCmAL_env"
source $pdirectory/AIROCmAL/AIROCmAL_env/bin/activate
echo "Installing pip..."
cd $pdirectory/AIROCmAL/Scripts
curl -sSL https://bootstrap.pypa.io/get-pip.py -o get-pip.py
python get-pip.py
cd $pdirectory/AIROCmAL
echo ""
echo "Installing wheel package..."
pip install wheel
echo ""
echo "Installing packages from requirements_AIROCmAL.txt..."
pip install -r requirements_AIROCmAL.txt
echo ""
#echo "Activating environment -> AIROCmAL_env_inf"
#source $pdirectory/AIROCmAL/AIROCmAL_env_inf/bin/activate
#echo "Installing pip..."
#cd $pdirectory/AIROCmAL/Scripts
#curl -sSL https://bootstrap.pypa.io/get-pip.py -o get-pip.py
#python get-pip.py
#cd $pdirectory/AIROCmAL
#echo ""
#echo "Installing wheel package..."
#pip install wheel
#echo ""
echo "Installing packages from requirements_AIROCmAL.txt..."
pip install -r requirements_AIROCmAL.txt
#pip install ipex-llm[xpu]
ln -sf $pdirectory/AIROCmAL/Scripts/ipex-llm-init $pdirectory/AIROCmAL/AIROCmAL_env/bin/
#ln -sf $pdirectory/AIROCmAL/Scripts/ipex-llm-init $pdirectory/AIROCmAL/AIROCmAL_env_inf/bin/
echo ""
echo "Initializing the AIROCmAL command."
ln -sf $pdirectory/AIROCmAL/Scripts/AIROCmAL $pdirectory/AIROCmAL/AIROCmAL_env/bin/AIROCmAL
sudo ln -sf $pdirectory/AIROCmAL/AIROCmAL_env/bin/AIROCmAL /bin/AIROCmAL
#sudo chmod +x /bin/AIROCmAL
sudo chmod +x $pdirectory/AIROCmAL/AIROCmAL_env/bin/AIROCmAL
echo "Creating initial \"Shared\" directory...replace with yours afterward, if necssary (symlink allowed)"
if [ ! -d "$pdirectory/AIROCmAL/Shared" ]; then
  mv ./shared1 ./shared
fi
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
