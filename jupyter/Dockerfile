FROM jupyter/minimal-notebook
USER root
RUN adduser admin
USER $NB_UID
RUN /bin/bash -c 'pip install redis==2.10.6'
RUN /bin/bash -c 'pip install redis-py-cluster==1.3.6'
