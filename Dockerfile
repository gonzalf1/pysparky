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
    
    
RUN conda install 'r-randomforest'
RUN conda install 'r-mass'
RUN conda install     #'r-tree' && \
RUN conda install     #'r-e1071' && \
RUN conda install     #mgcv
RUN conda install     #quantregForest
RUN conda install     #ggplot2
RUN conda install     #knitr
RUN conda install     #rmarkdown
RUN conda install     #data.table
RUN conda install     #forecast
RUN conda install     #prophet
RUN conda install     #xts
RUN conda install     #zoo
RUN conda install     #highcharter
RUN conda install     #plotly
RUN conda install     #ggfortify
RUN conda install     #tseries
RUN conda install     #docstring
RUN conda install     #here
RUN conda install     #readr
#RUN conda install     #rgdal
#RUN conda install     #sp
#RUN conda install     #leaflet
#RUN conda install     #maps
#RUN conda install     #Hmisc
#RUN conda install     #owmr
#RUN conda install     #htmltools

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
