# Copyright (c) Jupyter Development Team.
# Distributed under the terms of the Modified BSD License.
FROM jupyter/minimal-notebook

LABEL maintainer="Jupyter Project <jupyter@googlegroups.com>"

USER $NB_UID

# Install Python 3 packages
# Remove pyqt and qt pulled in for matplotlib since we're only ever going to
# use notebook-friendly backends in these images
RUN conda install --quiet --yes \
    'pandas=0.23*' \
    'matplotlib=2.2*' \
    'numpy=1.14*' \
    'seaborn=0.8*' \
    'jupyterhub=0.8*'

USER root

USER $NB_UID
