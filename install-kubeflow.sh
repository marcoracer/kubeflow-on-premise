#!/bin/bash

export KF_NAME=k8s-kfhom
export BASE_DIR=/opt
export KF_DIR=${BASE_DIR}/${KF_NAME}
export CONFIG_URI="https://raw.githubusercontent.com/kubeflow/manifests/v1.1-branch/kfdef/kfctl_k8s_istio.v1.1.0.yaml"
export CONFIG_FILE=${KF_DIR}/kfctl_k8s_istio.v1.1.0.yaml
sudo mkdir -p ${KF_DIR}
sudo chmod 777 -R ${KF_DIR}
cd ${KF_DIR}
kfctl build -V -f ${CONFIG_URI}
kfctl apply -V -f ${CONFIG_FILE}
