#!/bin/bash
echo "---------------------------------------- Creating OPA Gatekeeper constraints --------------------------"
kubectl apply -f ./../gatekeeper/constraint-templates
kubectl apply -f ./../gatekeeper/constraints
echo
# не указываем неймспейс, установится в default, там нет PSA, но действуют политики OPA Gateway
echo "---------------------------------------- Testing insecure pods ----------------------------------------"
kubectl apply -f ./../insecure-manifests
echo
echo "---------------------------------------- Testing secure pod -------------------------------------------"
kubectl apply -f ./../secure-manifests
echo
# для идемпотентности зачищаем всё
echo "---------------------------------------- Deleting created pods -----------------------------------------"
echo
kubectl delete -f ./../secure-manifests
echo "---------------------------------------- Deleting OPA Gatekeeper constraints ---------------------------"
kubectl delete -f ./../gatekeeper/constraints
