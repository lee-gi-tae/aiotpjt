#!/usr/bin/env bash
set -e
echo "===== 1. 초기화: 기존 NVIDIA 관련 컴포넌트 완전 삭제 ====="
sudo apt-get --purge remove -y "*cublas*" "cuda*" "nsight*" "nvidia*" "*cudnn*" "*tensorrt*"
sudo apt-get autoremove -y
sudo rm -rf /usr/local/cuda* /usr/include/cudnn* /usr/lib/aarch64-linux-gnu/libcudnn* /usr/lib/aarch64-linux-gnu/libnvinfer*
pip3 uninstall -y torch torchvision torchaudio || true
sudo rm -rf ~/.cache/torch

echo "===== 2. JetPack Compute Stack 설치 준비 ====="
sudo apt update
sudo apt install -y python3-pip curl libopenblas-dev

echo "===== 3. NVIDIA 저장소 등록 및 JetPack 설치 ====="
sudo sh -c 'echo "deb https://repo.download.nvidia.com/jetson/common r36.4 main" > /etc/apt/sources.list.d/nvidia-l4t-apt-source.list'
sudo sh -c 'echo "deb https://repo.download.nvidia.com/jetson/t234 r36.4 main" >> /etc/apt/sources.list.d/nvidia-l4t-apt-source.list'
sudo apt update
sudo apt install -y nvidia-jetpack

echo "===== 4. 공식 pip 인덱스 자동으로 PyTorch 설치 ====="
pip3 install --upgrade pip numpy
pip3 install torch torchvision torchaudio --extra-index-url https://download.pytorch.org/whl/jet/arm64

echo "===== 5. 설치 확인 ====="
echo "→ JetPack 버전: $(dpkg-query --show nvidia-jetpack || echo '설치 안됨')"
echo "→ nvcc 버전:"
nvcc --version || echo "nvcc 없음"
echo "→ PyTorch + CUDA 확인:"
python3 - <<EOF
import torch
print("Torch:", torch.__version__)
print("CUDA available:", torch.cuda.is_available())
print("CUDA version:", torch.version.cuda)
EOF

echo "✅ 전체 설치 완료했습니다!"
