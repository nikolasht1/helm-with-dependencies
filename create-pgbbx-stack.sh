#!/bin/bash

cd /home/ubuntu/helm-with-dependencies/

helm repo update

kubectl create namespace monitoring

helm install k-prom-black ./universe-test/ --namespace monitoring

export $(grep -v '^#' .env | xargs)

helm upgrade --install k-prom-black ./universe-test/ -n monitoring -f ./universe-test/custom-values.yaml \
	--set grafana.adminUser=$GRAFANA_USER \
	--set grafana.adminPassword=$GRAFANA_PASSWORD \
	--set grafana.dashboards.default.blackbox-exporter-http-prober.gnetId=$GRAFANA_DASHBOARD
