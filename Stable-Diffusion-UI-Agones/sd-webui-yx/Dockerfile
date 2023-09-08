# Copyright 2023 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

FROM nvidia/cuda:11.8.0-runtime-ubuntu22.04
# FROM nvidia/cuda:11.8.0-devel-ubuntu22.04

RUN set -ex && \
    apt update && \
    apt install -y wget git libglib2.0-0 pkg-config libcairo2-dev ffmpeg libsm6 libxext6 libtcmalloc-minimal4 && \
    rm -rf /var/lib/apt/lists/*

# 参考: /Users/yuanxiao/workspace/0yxgithub/Stable-Diffusion-on-GCP/Stable-Diffusion-UI-Novel/docker_inference/Dockerfile.finally.yx

ENV LD_LIBRARY_PATH $LD_LIBRARY_PATH:/usr/local/cuda/lib64
RUN ln -s /usr/local/cuda/lib64/libcudart.so.11.0 /usr/local/cuda/lib64/libcudart.so

WORKDIR /opt
RUN ls -l /opt


RUN wget https://repo.anaconda.com/miniconda/Miniconda3-py38_23.1.0-1-Linux-x86_64.sh
RUN chmod -Rf 777 Miniconda3-py38_23.1.0-1-Linux-x86_64.sh&&chmod +x Miniconda3-py38_23.1.0-1-Linux-x86_64.sh

RUN set -ex \
    && bash Miniconda3-py38_23.1.0-1-Linux-x86_64.sh -b -p /opt/miniconda3 \
    && /opt/miniconda3/bin/conda init \
    && /opt/miniconda3/bin/conda create -y --name py310_sdwebui python=3.10 \
    && /opt/miniconda3/bin/conda install -y -n py310_sdwebui virtualenv \
    && git clone https://github.com/AUTOMATIC1111/stable-diffusion-webui \
    && cd stable-diffusion-webui \
    && git checkout -b develop f865d3e11647dfd6c7b2cdf90dde24680e58acd8 \
    && /opt/miniconda3/envs/py310_sdwebui/bin/python -m pip install cython==0.29.36 \
    && cd extensions \
    && git clone  https://github.com/d8ahazard/sd_dreambooth_extension && cd sd_dreambooth_extension && git checkout -b develop  c2a5617c587b812b5a408143ddfb18fc49234edf && cd .. \
    && git clone https://github.com/Mikubill/sd-webui-controlnet.git && cd sd-webui-controlnet && git checkout -b develop 098f6cd887ac5f6f5f0e7cc9d81460095d2be012 && cd .. \
    && git clone https://github.com/KohakuBlueleaf/a1111-sd-webui-lycoris.git && cd a1111-sd-webui-lycoris && git checkout -b develop  8e97bf54867c25d00fc480be1ab4dae5399b35ef && cd .. \
    && git clone https://github.com/DominikDoom/a1111-sd-webui-tagcomplete.git && cd a1111-sd-webui-tagcomplete && git checkout -b develop 2.6.0 && cd .. \
    && git clone https://github.com/fkunn1326/openpose-editor && cd openpose-editor && git checkout -b develop  722bca6fb9b062815d13b950e7040589abaec797 && cd .. \
    && git clone https://github.com/hnmr293/posex && cd posex && git checkout -b develop 292f92d5068046f988fe002eb0a43b8841ad449e && cd .. \
    && git clone https://github.com/kohya-ss/sd-webui-additional-networks && cd sd-webui-additional-networks && git checkout -b develop v0.5.0 && cd .. \
    && git clone https://github.com/jexom/sd-webui-depth-lib.git && cd sd-webui-depth-lib && git checkout -b develop  efa9f616b30ea0f27e5dadf40ab41815012d1d78 && cd .. \
    && git clone https://github.com/thomasasfk/sd-webui-aspect-ratio-helper.git && cd sd-webui-aspect-ratio-helper && git checkout -b develop  99fcf9b0a4e3f8c8cac07b12d17b66f12297b828 && cd .. \
    && git clone https://github.com/AUTOMATIC1111/stable-diffusion-webui-rembg.git && cd stable-diffusion-webui-rembg && git checkout -b develop  3d9eedbbf0d585207f97d5b21e42f32c0042df70 && cd .. \
    && git clone https://github.com/picobyte/stable-diffusion-webui-wd14-tagger.git && cd stable-diffusion-webui-wd14-tagger && git checkout -b develop  v1.1.1 && cd .. \
    && git clone https://github.com/Coyote-A/ultimate-upscale-for-automatic1111.git && cd ultimate-upscale-for-automatic1111 && git checkout -b develop c99f382b31509b87b4d512e70e9caf08ae7a079f && cd .. \
    && cd /opt/stable-diffusion-webui;/opt/miniconda3/envs/py310_sdwebui/bin/python -c "import launch;launch.prepare_environment();" --skip-torch-cuda-test


ENV SAFETENSORS_FAST_GPU=1
ENV LD_PRELOAD="/usr/lib/x86_64-linux-gnu/libtcmalloc_minimal.so.4"

# RUN set -ex \
#     && /opt/miniconda3/envs/py310_sdwebui/bin/python -m pip install tensorrt==8.6.0
ARG CUDNN_PATH=$(dirname $(/root/miniconda3/envs/py310_sdwebui/bin/python -c "import nvidia.cudnn;print(nvidia.cudnn.__file__)"))
ARG TENSORRT_PATH=$(dirname $(/root/miniconda3/envs/py310_sdwebui/bin/python -c "import tensorrt;print(tensorrt.__file__)"))
ENV LD_LIBRARY_PATH $LD_LIBRARY_PATH:/usr/local/cuda/lib64:$CUDNN_PATH:$TENSORRT_PATH

EXPOSE 7860


COPY dockerdata/start.sh  /opt/stable-diffusion-webui/start.sh
COPY dockerdata/start_debug.sh  /opt/stable-diffusion-webui/start_debug.sh
COPY dockerdata/config.json /opt/stable-diffusion-webui/config.json

WORKDIR /opt/stable-diffusion-webui/
CMD /bin/sh -c './start.sh'
# CMD ["python3", "webui.py", "--listen", "--opt-sdp-attention", "--enable-insecure-extension-access", "--api"]
