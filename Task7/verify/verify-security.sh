#!/bin/bash

kubectl apply -f ./../gatekeeper/constraint-templates
kubectl apply -f ./../gatekeeper/templates

# не указываем неймспейс, установится в default, там нет PSA, но действуют политики OPA Gateway
kubectl apply -f ./../insecure-manifests
kubectl apply -f ./../secure-manifests

# для идемпотентности зачищаем всё
kubectl delete -f ./../secure-manifests
kubectl delete -f ./../gatekeeper/templates
