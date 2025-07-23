#!/bin/bash
set -e

# 1. 초기화
sudo apt-get --purge remove -y "*cublas*" "cuda*" "nsight*" "nvidia*" "*cudnn*" "*tensorrt*"
sudo apt-get autoremove -y
sudo rm -rf /usr/local/cuda* /usr/include/cudnn* /usr/lib/aarch64-linux-gnu/libcudnn* /usr/lib/aarch64-linux-gnu/libnvinfer*
pip3 uninstall -y torch torchvision torchaudio || true
sudo rm -rf ~/.cache/torch

# 2. JetPack 설치 준비
sudo apt update
sudo apt install -y python3-pip curl libopenblas-dev
echo "deb https://repo.download.nvidia.com/jetson/common r36.4 main" | sudo tee /etc/apt/sources.list.d/nvidia-l4t-apt-source.list
echo "deb https://repo.download.nvidia.com/jetson/t234 r36.4 main" | sudo tee -a /etc/apt/sources.list.d/nvidia-l4t-apt-source.list
sudo apt update
sudo apt install -y nvidia-jetpack

# 3. cuSPARSELT 설치
curl -OL https://developer.download.nvidia.com/compute/cusparselt/redist/libcusparse_lt/linux-aarch64/libcusparse_lt-linux-aarch64-0.6.3.2-archive.tar.xz
tar xf libcusparse_lt*.tar.xz
sudo cp -a libcusparse_lt*/include/* /usr/local/cuda/include/
sudo cp -a libcusparse_lt*/lib/* /usr/local/cuda/lib64/
sudo ldconfig

# 4. PyTorch 설치
python3 -m pip install --upgrade pip numpy
pip3 install --no-cache https://developer.download.nvidia.com/compute/redist/jp/v61/pytorch/torch-2.5.0a0+872d972e41.nv24.08.17622132-cp310-cp310-linux_aarch64.whl
# torchvision/torchaudio (주소 자동 재지정)
pip3 install --no-cache torchaudio-2.5.0*.whl torchvision-0.18*.whl

# 5. 확인
echo "===" 
dpkg-query --show nvidia-jetpack
nvcc --version
python3 - <<EOF
import torch
print("Torch:", torch.__version__, "CUDA:", torch.cuda.is_available())
EOF
