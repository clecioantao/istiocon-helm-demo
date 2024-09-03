#!/bin/bash

# Instalar o Istio com as configurações especificadas
istioctl install --set profile=default --set meshConfig.outboundTrafficPolicy.mode=REGISTRY_ONLY -y

# Verificar e aplicar o CRD do Gateway API se não estiver presente
kubectl get crd gateways.gateway.networking.k8s.io &> /dev/null || { 
    kubectl apply -k "github.com/kubernetes-sigs/gateway-api/config/crd?ref=v1.1.0"; 
}

# Aguardar um tempo para garantir que os CRDs sejam aplicados
sleep 5

# Rotular o namespace padrão para injeção automática de sidecar
kubectl label namespace default istio-injection=enabled

# Aplicar o Gateway e o deployment Sleep
kubectl apply -f gateway.yaml
kubectl apply -f https://raw.githubusercontent.com/istio/istio/master/samples/sleep/sleep.yaml
