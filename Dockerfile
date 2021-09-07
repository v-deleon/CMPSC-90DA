ARG BASE_IMAGE=jupyter/scipy-notebook:latest
FROM $BASE_IMAGE

LABEL maintainer="Vanessa De Leon <v_deleon@ucsb.edu>"

USER root

RUN apt-get update && \
    apt-get install -y vim

USER $NB_USER

RUN conda update -n base conda && \
    conda update python && \
    pip install vdiff

RUN \
    # Notebook extensions (TOC extension)
    pip install jupyter_contrib_nbextensions && \
    jupyter contrib nbextension install --sys-prefix && \
    jupyter nbextension enable toc2/main --sys-prefix && \
    jupyter nbextension enable toggle_all_line_numbers/main --sys-prefix && \
    jupyter nbextension enable table_beautifier/main --sys-prefix && \
    \
    # Notebook extensions configurator (server on and interface off)
    jupyter nbextension install jupyter_nbextensions_configurator --py --sys-prefix && \
    jupyter nbextensions_configurator disable --sys-prefix && \
    jupyter serverextension enable jupyter_nbextensions_configurator --sys-prefix && \
    \
    # remove cache
    rm -rf ~/.cache/pip ~/.cache/matplotlib ~/.cache/yarn && \
    rm -rf /opt/conda/share/jupyter/lab/extensions/jupyter-matplotlib-0.7.1.tgz

#--- Install nbgitpuller
RUN pip install nbgitpuller && \
    jupyter serverextension enable --py nbgitpuller --sys-prefix

RUN \
    pip install \ 
        nodejs \
        spacy \
        nltk \
        mplcursors \
        pytest \
        tweepy \
        PTable \
        pytest-custom-report\ \
        datascience \
        jupyterlab 
    #conda install -c conda-forge nodejs && \
    #conda install -c conda-forge spacy && \
    #conda install --quiet -y nltk && \
    #conda install --quiet -y mplcursors && \
    #conda install --quiet -y pytest && \
    #conda install --quiet -y tweepy
ARG RPY2_CFFI_MODE=ABI
# Install otter-grader 
RUN pip install otter-grader==2.2.4
RUN python -m pip install --upgrade pip
RUN npm install -g npm@latest
RUN npm install -g codemirror

RUN fix-permissions $CONDA_DIR && \
    fix-permissions /home/$NB_USER
