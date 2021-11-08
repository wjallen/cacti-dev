# Copyright 2021 DeepMind Technologies Limited
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

ARG CUDA=10.2
FROM nvidia/cuda-ppc64le:${CUDA}-base
# FROM directive resets ARGS, so we specify again (the value is retained if
# previously set).
ARG CUDA

# Use bash to support string substitution.
SHELL ["/bin/bash", "-c"]

RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y \
      build-essential \
      cmake \
      cuda-command-line-tools-${CUDA/./-} \
      gcc-8 \
      g++-8 \
      git \
      hmmer \
      kalign \
      tzdata \
      wget \
    && rm -rf /var/lib/apt/lists/*

# set gcc-8 as the default
RUN update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-7 7 \
    && update-alternatives --install /usr/bin/g++ g++ /usr/bin/g++-7 7 \
    && update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-8 8 \
    && update-alternatives --install /usr/bin/g++ g++ /usr/bin/g++-8 8

# Compile HHsuite from source.
RUN git clone --branch v3.3.0 https://github.com/soedinglab/hh-suite.git /tmp/hh-suite \
    && mkdir /tmp/hh-suite/build
WORKDIR /tmp/hh-suite/build
RUN cmake -DCMAKE_INSTALL_PREFIX=/opt/hhsuite .. \
    && make -j 4 && make install \
    && ln -s /opt/hhsuite/bin/* /usr/bin \
    && rm -rf /tmp/hh-suite

# Install Miniconda package manger.
RUN wget -q -P /tmp \
  https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-ppc64le.sh \
    && bash /tmp/Miniconda3-latest-Linux-ppc64le.sh -b -p /opt/conda \
    && rm /tmp/Miniconda3-latest-Linux-ppc64le.sh

# Prepend PowerAI channel
ENV PATH="/opt/conda/bin:$PATH"
RUN conda config --system --prepend channels https://public.dhe.ibm.com/ibmdl/export/pub/software/server/ibm-ai/conda/ \
    && conda config --system --set channel_priority strict
# Accept IBM license
ENV IBM_POWERAI_LICENSE_ACCEPT=yes

# Install conda packages.
RUN conda update -qy conda \
    && conda install -y -c conda-forge \
      openmm=7.5.1 \
      cudatoolkit==${CUDA}.89 \
      pdbfixer \
      pip \
      python=3.7

COPY . /app/alphafold
RUN wget -q -P /app/alphafold/alphafold/common/ \
  https://git.scicore.unibas.ch/schwede/openstructure/-/raw/7102c63615b64735c4941278d92b554ec94415f8/modules/mol/alg/src/stereo_chemical_props.txt
#
# Install pip packages.
RUN pip3 install --upgrade pip \
    && pip3 install -r /app/alphafold/requirements.txt \
    && pip3 install --upgrade jax jaxlib==0.1.69+cuda${CUDA/./} -f \
      https://storage.googleapis.com/jax-releases/jax_releases.html

# Apply OpenMM patch.
WORKDIR /opt/conda/lib/python3.7/site-packages
RUN patch -p0 < /app/alphafold/docker/openmm.patch

# We need to run `ldconfig` first to ensure GPUs are visible, due to some quirk
# with Debian. See https://github.com/NVIDIA/nvidia-docker/issues/1399 for
# details.
# ENTRYPOINT does not support easily running multiple commands, so instead we
# write a shell script to wrap them up.
WORKDIR /app/alphafold
RUN echo $'#!/bin/bash\n\
ldconfig\n\
python /app/alphafold/run_alphafold.py "$@"' > /app/run_alphafold.sh \
  && chmod +x /app/run_alphafold.sh
ENTRYPOINT ["/app/run_alphafold.sh"]
