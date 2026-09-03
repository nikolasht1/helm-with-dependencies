#!/bin/bash

helm repo update

kubectl create namespace monitoring

helm install k-prom-black prometheus-community/prometheus-blackbox-exporter --namespace monitoring -f blackbox-values.yaml

helm upgrade --install k-prom-black prometheus-community/prometheus-blackbox-exporter -n monitoring -f blackbox-values.yaml

helm install k-prom-stack prometheus-community/kube-prometheus-stack --namespace monitoring -f kube-prometheus-values.yaml

export $(grep -v '^#' .env | xargs)

helm upgrade --install k-prom-stack prometheus-community/kube-prometheus-stack -n monitoring -f kube-prometheus-values.yaml \
	--set grafana.adminUser=$GRAFANA_USER \
	--set grafana.adminPassword=$GRAFANA_PASSWORD \
	--set grafana.dashboards.default.blackbox-exporter-http-prober.gnetId=$GRAFANA_DASHBOARD

kubectl apply -f google-probe.yaml

#sleep 40

#kubectl port-forward svc/k-prom-stack-grafana 3000:80 -n monitoring
