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


# R packages
RUN conda install --quiet --yes \
    'r-base=3.4.5' \
    'r-irkernel=0.8*' \
    'r-ggplot2=3.1*' \
    'r-sparklyr=0.9*' \
    'r-rcurl=1.95*' && \
    #'r-randomforest' && \
    'r-mass=7.3' && \
    #'r-tree' && \
    #'r-e1071' && \
    #'r-xg' && \
    #mgcv
    #quantregForest
    #ggplot2
    #knitr
    #rmarkdown
    #data.table
    #forecast
    #prophet
    #xts
    #zoo
    #highcharter
    #dygraphs
    #plotly
    #ggfortify
    #tseries
    #gridExtra
    #docstring
    #here
    #readr
    #rgdal
    #sp
    #leaflet
    #maps
    #Hmisc
    #owmr
    #htmltools
    
    conda clean -tipsy && \
    fix-permissions $CONDA_DIR && \
    fix-permissions /home/$NB_USER

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
