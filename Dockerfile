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
RUN conda install 'r-randomforest'
RUN conda install 'r-mass'
RUN conda install 'r-tree'
RUN conda install 'r-e1071'
RUN conda install 'r-mgcv'
RUN conda install 'r-quantregforest'
RUN conda install 'r-ggplot2'
RUN conda install 'r-knitr'
RUN conda install 'r-rmarkdown'
RUN conda install 'r-data.table'
RUN conda install 'r-forecast'
RUN conda install 'r-prophet'
RUN conda install 'r-xts'
RUN conda install 'r-zoo'
RUN conda install 'r-highcharter'
RUN conda install 'r-plotly'
RUN conda install 'r-ggfortify'
RUN conda install 'r-tseries'
RUN conda install 'r-docstring'
RUN conda install 'r-here'
RUN conda install 'r-readr'
#RUN conda install #'r-rgdal'
#RUN conda install #'r-sp'
#RUN conda install #'r-leaflet'
#RUN conda install #'r-maps'
#RUN conda install #'r-Hmisc'
#RUN conda install #'r-owmr'
#RUN conda install #'r-htmltools'

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
