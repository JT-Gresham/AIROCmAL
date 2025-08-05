#!/usr/bin/env bash

##### This code was taken directly from PyTorch and modified to fit the AIROCmAL framework #####

source /etc/AIROCmAL/AIROCmAL_path

# Defined variables
# pdirectory = The parent directory AIROCmAL is installed in
# AIROCmALdir = The full path to the AIROCmAL directory

# Activate AIROCmAL python environment
source $AIROCmALdir/AIROCmAL_env/bin/activate

if [ ! -d "$AIROCmALdir/AIROCmAL_env/lib/python3.11/site-packages/torch" ]; then
    mkdir $AIROCmALdir/AIROCmAL_env/lib/python3.11/site-packages/torch
fi
cd $AIROCmALdir/AIROCmAL_env/lib/python3.11/site-packages/torch
# Get PyTorch Source Code
#cd $AIROCmALdir/AIROCmAL_env/lib/python3.11/site-packages
git clone --recursive https://github.com/pytorch/pytorch
cd pytorch
git checkout main # or checkout the specific release version >= v2.4
git submodule sync
git submodule update --init --recursive

# Get required packages for compilation
pip install cmake ninja
pip install -r requirements.txt

# Pytorch for Intel GPUs only support Linux platform for now.
# Install the required packages for pytorch compilation.
pip install mkl-static mkl-include

# (optional) If using torch.compile with inductor/triton, install the matching version of triton
# Run from the pytorch directory after cloning
# For Intel GPU support, please explicitly `export USE_XPU=1` before running command.
export USE_XPU=1
export USE_XPU=1 make triton
export USE_VULKAN=1
export USE_VULKAN_SHADERC_RUNTIME=1
export USE_VULKAN_WRAPPER=0

# If you would like to compile PyTorch with new C++ ABI enabled, then first run this command:
export _GLIBCXX_USE_CXX11_ABI=1

# pytorch build from source
export CMAKE_PREFIX_PATH="$AIROCmALdir/AIROCmAL_env"
export USE_MPI=0
export USE_FBGEMM=0

python setup.py develop
cd ..

# (optional) If using torchvison.
# Get torchvision Code
git clone https://github.com/pytorch/vision.git
cd vision
git checkout main # or specific version
python setup.py develop
cd ..

# (optional) If using torchaudio.
# Get torchaudio Code
git clone https://github.com/pytorch/audio.git
cd audio
pip install -r requirements.txt
git checkout main # or specific version
git submodule sync
git submodule update --init --recursive
python setup.py develop
cd ..
