# Copyright (c) gonzalf1
# Distributed under the terms of the Modified BSD License.
ARG BASE_CONTAINER=jupyter/pyspark-notebook
FROM $BASE_CONTAINER

USER root

# RSpark config
ENV R_LIBS_USER $SPARK_HOME/R/lib
RUN fix-permissions $R_LIBS_USER

# R pre-requisites
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    fonts-dejavu \
    tzdata \
    gfortran \
    gcc && \
    rm -rf /var/lib/apt/lists/*

USER $NB_UID

#RUN conda update -n base -c defaults conda
# R packages
RUN conda install --quiet --yes \
    'r-base=3.5.1' \
    'r-irkernel=0.8*' \
    'r-ggplot2=3.1*' \
    'r-sparklyr=0.9*' \
    'r-rcurl=1.95*' && \
    conda clean -tipsy && \
    fix-permissions $CONDA_DIR && \
    fix-permissions /home/$NB_USER
    
#install additional libraries    
RUN conda install --yes -c cvxgrp cvxpy
RUN conda install --yes 'r-randomforest'
RUN conda install --yes 'r-mass'
RUN conda install --yes 'r-tree'
RUN conda install --yes 'r-e1071'
RUN conda install --yes 'r-mgcv'
#RUN conda install --yes 'r-quantregforest'
RUN conda install --yes 'r-ggplot2'
#RUN conda install --yes 'r-knitr'
RUN conda install --yes 'r-rmarkdown'
RUN conda install --yes 'r-data.table'
RUN conda install --yes 'r-forecast'
RUN conda install --yes 'r-prophet'
RUN conda install --yes 'r-xts'
RUN conda install --yes 'r-zoo'
RUN conda install --yes 'r-highcharter'
RUN conda install --yes 'r-plotly'
RUN conda install --yes 'r-ggfortify'
RUN conda install --yes 'r-tseries'
#RUN conda install --yes 'r-docstring'
RUN conda install 'r-here'
#RUN conda install 'r-readr'
#RUN conda install #--yes 'r-rgdal'
#RUN conda install #--yes 'r-sp'
#RUN conda install #--yes 'r-leaflet'
#RUN conda install #--yes 'r-maps'
#RUN conda install #--yes 'r-Hmisc'
#RUN conda install #--yes 'r-owmr'
#RUN conda install #--yes 'r-htmltools'

# Apache Toree kernel
RUN pip install --no-cache-dir \
    https://dist.apache.org/repos/dist/release/incubator/toree/0.3.0-incubating/toree-pip/toree-0.3.0.tar.gz \
    && \
    jupyter toree install --sys-prefix && \
    rm -rf /home/$NB_USER/.local && \
    fix-permissions $CONDA_DIR && \
    fix-permissions /home/$NB_USER

# Spylon-kernel
RUN conda install --quiet --yes 'spylon-kernel=0.4*' && \
    conda clean -tipsy && \
    python -m spylon_kernel install --sys-prefix && \
    rm -rf /home/$NB_USER/.local && \
    fix-permissions $CONDA_DIR && \
    fix-permissions /home/$NB_USER
