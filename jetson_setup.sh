#!/bin/bash

# ⚠️ JetPack 버전 확인하세요! 아래 변수에 맞춰 주세요
JETPACK_VER="6.0"       # 예: "6.0" 또는 "6.2"
TORCH_WHL="./torch-2.2.0a0+6a974be.nv23.11-cp310-cp310-linux_aarch64.whl"  # JetPack 6.0용

echo "🧹 1. 이전 설치 삭제"
sudo apt-get --purge remove "*cublas*" "*cudnn*" "cuda*" "nsight*" "nvidia*" -y
pip3 uninstall -y torch torchvision torchaudio
sudo apt autoremove -y && sudo apt clean
sudo rm -rf /usr/local/cuda* /usr/lib/python3*/dist-packages/torch* ~/.cache/torch

echo "📦 2. 의존 패키지 설치"
sudo apt update
sudo apt install -y python3-pip python3-dev build-essential cmake git curl libjpeg-dev zlib1g-dev libopenblas-dev liblapack-dev libx11-dev libgtk-3-dev python3-opencv
pip3 install --upgrade pip

echo "📥 3. PyTorch + TorchVision + 기타 설치"
pip3 install "$TORCH_WHL"
pip3 install torchvision==0.16.0+nv23.10 torchaudio==2.2.0+nv23.10 --extra-index-url https://pypi.ngc.nvidia.com
pip3 install ultralytics numpy flask requests paho-mqtt pyserial gTTS playsound speechrecognition pyaudio

echo "✅ 설치 완료"
python3 - <<EOF
import torch
print("Torch:", torch.__version__, "CUDA available:", torch.cuda.is_available())
import torchvision; print("TorchVision:", torchvision.__version__)
import torchaudio; print("TorchAudio:", torchaudio.__version__)
EOF
