FROM gcr.io/kubeflow-images-public/tensorflow-2.1.0-notebook-cpu:1.0.0

# LABEL maintainer="YOUR NAME"

USER root

#RUN pip install -U pip
RUN pip uninstall -y enum34
RUN pip install -U numpy
RUN pip install -U pandas
RUN pip install seaborn==0.11.1
RUN pip install flake8
RUN pip install ipykernel==5.3.4 ipython==7.16.1 ipywidgets==7.5.1
RUN pip install jupyterlab==2.2.9 notebook==6.1.5
RUN pip install xgboost==1.3.1
RUN pip install kedro==0.16.6
RUN pip install scikit-learn==0.24.0
RUN pip install --upgrade google-cloud
RUN pip install kfp

USER jovyan

#ENV GRANT_SUDO yes
#ENV CHOWN_HOME yes
#ENV CHOWN_HOME_OPTS '-R'

CMD ["sh","-c", "jupyter lab --notebook-dir=/home/${NB_USER} --ip=0.0.0.0 --no-browser --allow-root --port=8888 --NotebookApp.token='' --NotebookApp.password='' --NotebookApp.allow_origin='*' --NotebookApp.base_url=${NB_PREFIX}"]