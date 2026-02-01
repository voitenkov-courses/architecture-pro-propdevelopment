#!/bin/bash

kubectl apply -f ./../01-create-namespace.yaml

# указываем неймспейс audit-zone, проверяем PSA, ограничений OPA Gateway пока нет
kubectl apply -f ./../insecure-manifests -n audit-zone
kubectl apply -f ./../secure-manifests -n audit-zone

# для идемпотентности зачищаем всё
kubectl delete ns audit-zone
