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

# R packages
RUN conda install --quiet --yes \
    'r-base=3.4.1' \
    'r-irkernel=0.8*' \
    'r-plyr=1.8*' \
    'r-devtools=1.13*' \
    'r-tidyverse=1.1*' \
    'r-shiny=1.0*' \
    'r-rmarkdown=1.8*' \
    'r-forecast=8.2*' \
    'r-rsqlite=2.0*' \
    'r-reshape2=1.4*' \
    'r-nycflights13=0.2*' \
    'r-caret=6.0*' \
    'r-rcurl=1.95*' \
    'r-crayon=1.3*' \
    'r-randomforest=4.6*' \
    'r-htmltools=0.3*' \
    'r-sparklyr=0.7*' \
    'r-htmlwidgets=1.0*' \
   # 'r-topicmodels=0.2*' \
    'r-ggplot2=2.2*' \
   # 'r-tm=0.7*' \
   # 'r-NLP=0.1*' \
   # 'r-wordcloud=2.5*' \
    'r-RColorBrewer=1.1*' \
   # 'r-SnowballC=0.5*' \
    'r-networkD3=0.4*' \
    'r-png=0.1*' \
    'r-extrafont=0.17*' \
   # 'r-ndtv=0.1*' \
    'r-animation=2.5*' \
   # 'r-networkDynamic=0.*' \
   # 'r-sna=2*' \            
   # 'r-statnet.common=4*' \
    'r-network=1.13.0*' \
    'r-igraph=1.2.1*' \
    'r-stringr=1.3*' \
    'r-readr=1.1*' \
    'r-hexbin=1.27*' && \
    conda clean -tipsy && \
    fix-permissions $CONDA_DIR
