# Copyright (c) Jupyter Development Team.
# Distributed under the terms of the Modified BSD License.
FROM jupyter/minimal-notebook

LABEL maintainer="Jupyter Project <jupyter@googlegroups.com>"

USER root

# R pre-requisites
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    libfftw3-dev \
    fonts-dejavu \
    tzdata \
    gfortran \
    gcc && apt-get clean && \
    rm -rf /var/lib/apt/lists/*
RUN Rscript -e 'source("http://bioconductor.org/biocLite.R")' -e 'biocLite("graph")' -e 'biocLite("Rgraphviz")' -e 'install_github("sentiment140", "okugami79")' -e 'library("sentiment")'

USER $NB_UID

# Autoupdate notebooks https://github.com/data-8/nbgitpuller
RUN pip install git+https://github.com/data-8/nbgitpuller && \
    jupyter serverextension enable --py nbgitpuller

# R packages
RUN conda install --quiet --yes \
    'r-base=3.4.1' \
    'r-irkernel=0.8*' \
    'r-plyr=1.8*' \
    'r-devtools=1.13*' \
    'r-rcurl=1.95*' \
    'r-ggplot2=2.2*' \
    'r-twitteR=1.1*' \
    'r-tm=0.7*' \
    'r-data.table=1.1*' \
    'r-topicmodels=0.2*' \
    'r-wordcloud=2.5*' \
    'r-RColorBrewer=1.1*' \
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
