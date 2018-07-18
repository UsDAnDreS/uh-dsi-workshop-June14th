# Copyright (c) Jupyter Development Team.
# Distributed under the terms of the Modified BSD License.
FROM jupyter/minimal-notebook

LABEL maintainer="Jupyter Project <jupyter@googlegroups.com>"

USER root

# R pre-requisites
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    fonts-dejavu \
    tzdata \
    gfortran \
    gcc && apt-get clean && \
    rm -rf /var/lib/apt/lists/*

USER $NB_UID

# Autoupdate notebooks https://github.com/data-8/nbgitpuller
RUN pip install git+https://github.com/data-8/nbgitpuller && \
    jupyter serverextension enable --py nbgitpuller

# Install Python 3 packages
# Remove pyqt and qt pulled in for matplotlib since we're only ever going to
# use notebook-friendly backends in these images
RUN conda install --quiet --yes \
    'pandas=0.23*' \
    'matplotlib=2.2*' \
    'numpy=1.14*' \
    'seaborn=0.8*'
    'jupyterhub=0.8*'

# R packages
RUN conda install --quiet --yes \
    'r-base=3.4.1' \
    'r-hexbin=1.27*' && \
    conda clean -tipsy && \
    fix-permissions $CONDA_DIR

USER root

# For rJava
RUN apt-get update && apt-get install -y \
    openjdk-8-jre \
    openjdk-8-jdk 

RUN apt-get clean

##### R: COMMON PACKAGES
# To let R find Java
ENV LD_LIBRARY_PATH /usr/lib/jvm/java-8-openjdk-amd64/jre/lib/amd64:/usr/lib/jvm/java-8-openjdk-amd64/jre/lib/amd64/server
RUN R CMD javareconf

# Install R packages
RUN R -e "install.packages(c('rJava', 'tabulizer'), repos='http://cran.rstudio.com/')"

USER $NB_UID
