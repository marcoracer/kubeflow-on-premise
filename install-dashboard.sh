#!/bin/bash

kubectl apply -f https://github.com/kubernetes-sigs/metrics-server/releases/download/v0.3.6/components.yaml
kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/v2.0.0/aio/deploy/recommended.yaml
kubectl apply -f ./dashboard/recommended.yaml
kubectl apply -f ./dashboard/dashboard-admin.yaml
kubectl apply -f ./dashboard/dashboard-read-only.yaml
chmod +x ./dashboard/dashboard.sh
sudo cp ./dashboard/dashboard.sh /usr/local/bin/dashboard
