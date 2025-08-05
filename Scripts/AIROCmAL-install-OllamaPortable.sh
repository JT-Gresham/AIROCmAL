#!/usr/bin/env bash

source /etc/AIROCmAL/AIROCmAL_path
source $AIROCmALdir/libref
source $AIROCmALdir/AIROCmAL_env/bin/activate
aiinaalpkg="Ollama"
#aiinaalpkgURL="https://github.com/intel/ipex-llm/releases/download/v2.2.0-nightly/ollama-ipex-llm-2.2.0b20250318-ubuntu.tgz"
aiinaalpkgURL="https://github.com/ipex-llm/ipex-llm/releases/download/v2.2.0/ollama-ipex-llm-2.2.0-ubuntu.tgz"
aiinaaluser=$(whoami)

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
mkdir /tmp/$aiinaalpkg
cd /tmp/$aiinaalpkg
echo ""
echo "Downloading official $aiinaalpkg package to /tmp/$aiinaalpkg"
wget $aiinaalpkgURL
echo ""
echo "Decompressing Ollama package..."
tgzpkg=$(ls | grep "tgz")
tgzpkgname=$(echo $tgzpkg | head -c -5)
tar -xvf $tgzpkg
echo ""
echo "Copying library files to AIROCmAL environment..."
rm -rf $AIROCmALdir/AIROCmAL_env/lib/python3.11/site-packages/ollama
mv /tmp/Ollama/$tgzpkgname $AIROCmALdir/AIROCmAL_env/lib/python3.11/site-packages/ollama
echo "Checking start-ollama.sh"
cd $AIROCmALdir/AIROCmAL_env/lib/python3.11/site-packages/ollama
  if grep -Fxq "./ollama serve" start-ollama.sh
    then
      echo ".ollama serve found in start-ollama.sh...correcting"
      sed -i 's|./ollama serve|ollama serve|g' start-ollama.sh
    else
      echo "Check PASSED"
  fi
echo "Cleaning up temporary files..."
cd $AIROCmALdir/$aiinaalpkg
rm -R /tmp/Ollama
echo ""

source $AIROCmALdir/$aiinaalpkg/libref-$aiinaalpkg
echo ""
#echo "Applying AIROCmAL modifications to original $aiinaalpkg..."
#cp -n "$AIROCmALdir/$aiinaalpkg/user_customize_Ollama_example.sh" "$AIROCmALdir/$aiinaalpkg/user_customize_Ollama.sh"
AIROCmAL_update_$aiinaalpkg
cd $AIROCmALdir/$aiinaalpkg
AIROCmAL update Torch
pip install -r requirements_$aiinaalpkg.txt
AIROCmAL update Intel

mkdir -p "$AIROCmALdir/$aiinaalpkg/.ollama/models"
ln -sf "$AIROCmALdir/$aiinaalpkg/" "/home/$aiinaaluser/.ollama"
echo "Initializing Ollama with IPEX for your GPU..."
#Create symlinks for ipex, ollama, and openwebui
#ln -sf $AIROCmALdir/AIROCmAL_env/bin/ipexrun ipexrun
init-ollama
ln -sf $AIROCmALdir/AIROCmAL_env/bin/open-webui open-webui
echo ""

echo "Creating the launcher file ($aiinaalpkg-Start.sh)"
echo "#!/usr/bin/env bash" > $AIROCmALdir/$aiinaalpkg/$aiinaalpkg-Start.sh
echo "" >> $AIROCmALdir/$aiinaalpkg/$aiinaalpkg-Start.sh
echo "source /etc/AIROCmAL/AIROCmAL_path" >> $AIROCmALdir/$aiinaalpkg/$aiinaalpkg-Start.sh
echo "source $AIROCmALdir/libref" >> $AIROCmALdir/$aiinaalpkg/$aiinaalpkg-Start.sh
echo "source $AIROCmALdir/$aiinaalpkg/libref-$aiinaalpkg" >> $AIROCmALdir/$aiinaalpkg/$aiinaalpkg-Start.sh
echo "source $AIROCmALdir/AIROCmAL_env/bin/activate" >> $AIROCmALdir/$aiinaalpkg/$aiinaalpkg-Start.sh
echo "AIROCmAL_update" >> $AIROCmALdir/$aiinaalpkg/$aiinaalpkg-Start.sh

echo "Creating the new /usr/bin/ollama executable..."
echo "#!/usr/bin/env bash" > ollama
echo "" >> ollama
echo "set -e" >> ollama
echo "exec $AIROCmALdir/AIROCmAL_env/lib/python3.11/site-packages/ollama/ollama \"\$@\"" >> ollama
sudo ln -sf $AIROCmALdir/$aiinaalpkg/ollama /usr/bin/ollama
#### Executable below
echo "#export OLLAMA_DEBUG=1" >> $AIROCmALdir/$aiinaalpkg/$aiinaalpkg-Start.sh
echo "#export OLLAMA_USE_OPENVINO=true" >> $AIROCmALdir/$aiinaalpkg/$aiinaalpkg-Start.sh
echo "#export OLLAMA_USE_DEVICE=0" >> $AIROCmALdir/$aiinaalpkg/$aiinaalpkg-Start.sh
echo "#export OLLAMA_DISABLE_CPU=1" >> $AIROCmALdir/$aiinaalpkg/$aiinaalpkg-Start.sh
echo "export OLLAMA_INTEL_GPU=true" >> $AIROCmALdir/$aiinaalpkg/$aiinaalpkg-Start.sh
echo "export OLLAMA_NUM_GPU=999" >> $AIROCmALdir/$aiinaalpkg/$aiinaalpkg-Start.sh
echo "export OLLAMA_NUM_GPU_LAYERS=9999" >> $AIROCmALdir/$aiinaalpkg/$aiinaalpkg-Start.sh
echo "export TORCH_DEVICE_BACKEND_AUTOLOAD=0" >> $AIROCmALdir/$aiinaalpkg/$aiinaalpkg-Start.sh
echo "source ipex-llm-init -g --device Arc" >> $AIROCmALdir/$aiinaalpkg/$aiinaalpkg-Start.sh
echo "AIROCmAL_update_$aiinaalpkg" >> $AIROCmALdir/$aiinaalpkg/$aiinaalpkg-Start.sh
echo "cd $AIROCmALdir/AIROCmAL_env/lib/python3.11/site-packages/ollama" >> $AIROCmALdir/$aiinaalpkg/$aiinaalpkg-Start.sh
echo "./start-ollama.sh &" >> $AIROCmALdir/$aiinaalpkg/$aiinaalpkg-Start.sh
echo "cd $AIROCmALdir/$aiinaalpkg" >> $AIROCmALdir/$aiinaalpkg/$aiinaalpkg-Start.sh
echo "echo \"Open Web UI will start in 10 seconds. After it loads, you can open it up in your browser. (URL: localhost:8080)\"" >> $AIROCmALdir/$aiinaalpkg/$aiinaalpkg-Start.sh
echo "sleep 10" >> $AIROCmALdir/$aiinaalpkg/$aiinaalpkg-Start.sh
echo "" >> $AIROCmALdir/$aiinaalpkg/$aiinaalpkg-Start.sh
echo "open-webui serve" >> $AIROCmALdir/$aiinaalpkg/$aiinaalpkg-Start.sh
echo "Ollama_exit" >> $AIROCmALdir/$aiinaalpkg/$aiinaalpkg-Start.sh
#echo "sleep 60"
echo "Setting the new start file to be executable. (Authorization Required)"
sudo chmod +x $AIROCmALdir/$aiinaalpkg/$aiinaalpkg-Start.sh
echo "Creating executable link in /usr/bin --> AIROCmAL-$aiinaalpkg"
sudo ln -sf "$AIROCmALdir/$aiinaalpkg/$aiinaalpkg-Start.sh" "/usr/bin/AIROCmAL-$aiinaalpkg"
echo "Installation complete. Start with command: AIROCmAL-$aiinaalpkg with any Ollama arguments afterward"
echo "--Press any key to exit installer--"
read go
exit 0
