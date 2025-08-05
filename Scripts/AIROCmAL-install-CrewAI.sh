#!/usr/bin/env bash

source /etc/AIROCmAL/AIROCmAL_path
source $AIROCmALdir/libref
source $AIROCmALdir/AIROCmAL_env/bin/activate
aiinaalpkg="CrewAI"
aiinaalpkgURL="https://github.com/crewAIInc/crewAI.git"

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
cd /tmp
echo ""
echo "Cloning official $aiinaalpkg repository to $aiinaalpkg"

#### GIT CLONE COMMAND  URL HERE ####
#wget -O - https://github.com/crewAIInc/crewAI/archive/master.tar.gz | tar -xz --strip=2 "crewAI-main/src/crewai"
git clone "https://github.com/strnad/CrewAI-Studio.git"
cp -R /tmp/CrewAI-Studio/* $AIROCmALdir/$aiinaalpkg/
cp $AIROCmALdir/Scripts/crewai $AIROCmALdir/AIROCmAL_env/bin/
sed -i "s|10062024|#!$AIROCmALdir/$aiinaalpkg|g" $AIROCmALdir/AIROCmAL_env/bin/crewai
rmdir -R /tmp/crewai
cd $AIROCmALdir/$aiinaalpkg
source $AIROCmALdir/$aiinaalpkg/libref-$aiinaalpkg
echo ""
echo "Applying AIROCmAL modifications to original $aiinaalpkg..."
cp -n "$AIROCmALdir/"$aiinaalpkg"/user_customize_CrewAI_example.sh" "$AIROCmALdir/"$aiinaalpkg"/user_customize_CrewAI.sh"
AIROCmAL_update_$aiinaalpkg
#echo ""
#echo "Installing packages from requirements.txt..."
cd $AIROCmALdir/$aiinaalpkg
#sleep 1
pip install -r requirements.txt
#pip install -r requirements_$aiinaalpkg.txt
#echo ""
#echo "Creating the launcher file ($aiinaalpkg-Start.sh)"
#touch $AIROCmALdir/$aiinaalpkg/$aiinaalpkg-Start.sh
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
#echo "cd $AIROCmALdir/$aiinaalpkg/MyCrewAIProjects" >> $AIROCmALdir/$aiinaalpkg/$aiinaalpkg-Start.sh
echo "streamlit run app/app.py --server.headless True \"\$@\"" >> $AIROCmALdir/$aiinaalpkg/$aiinaalpkg-Start.sh
#echo "python3 $AIROCmALdir/AIROCmAL_env/bin/crewai \"\$@\"" >> $AIROCmALdir/$aiinaalpkg/$aiinaalpkg-Start.sh
#echo "sleep 60"
echo "Setting the new start file to be executable. (Authorization Required)"
sudo chmod +x $AIROCmALdir/$aiinaalpkg/$aiinaalpkg-Start.sh
echo "Creating executable link in /usr/bin --> AIROCmAL-$aiinaalpkg"
sudo ln -sf "$AIROCmALdir/$aiinaalpkg/$aiinaalpkg-Start.sh" "/usr/bin/AIROCmAL-$aiinaalpkg"
echo "Installation complete. Start with command: AIROCmAL-$aiinaalpkg with any CrewAI arguments afterward"
echo "--Press any key to exit installer--"
read go
exit 0
