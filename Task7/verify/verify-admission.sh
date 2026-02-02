#!/bin/bash
echo "---------------------------------------- Creating namespace -------------------------------------------"
kubectl apply -f ./../01-create-namespace.yaml
echo
# указываем неймспейс audit-zone, проверяем PSA, ограничений OPA Gateway пока нет
echo "---------------------------------------- Testing insecure pods ----------------------------------------"
kubectl apply -f ./../insecure-manifests -n audit-zone
echo
echo "---------------------------------------- Testing secure pod -------------------------------------------"
kubectl apply -f ./../secure-manifests -n audit-zone
echo
# для идемпотентности зачищаем всё
echo "---------------------------------------- Deleting namespace -------------------------------------------"
kubectl delete ns audit-zone
