#!/bin/bash

# генерируем приватные ключи
openssl genrsa -out bob.key 2048
openssl genrsa -out alice.key 2048
openssl genrsa -out mike.key 2048
openssl genrsa -out john.key 2048

# генерируем CSR
openssl req -new -key bob.key -out bob.csr -subj "/CN=bob/O=developers"
openssl req -new -key alice.key -out alice.csr -subj "/CN=bob/O=engineers"
openssl req -new -key mike.key -out mike.csr -subj "/CN=bob/O=security"
openssl req -new -key john.key -out john.csr -subj "/CN=bob/O=devops-engineers"

# создаем CSR объекты в Kubernetes
cat <<EOF | kubectl apply -f -
apiVersion: certificates.k8s.io/v1
kind: CertificateSigningRequest
metadata:
  name: bob-csr
spec:
  request: $(cat bob.csr | base64 | tr -d '\n')
  signerName: kubernetes.io/kube-apiserver-client
  usages:
  - client auth
EOF

cat <<EOF | kubectl apply -f -
apiVersion: certificates.k8s.io/v1
kind: CertificateSigningRequest
metadata:
  name: alice-csr
spec:
  request: $(cat alice.csr | base64 | tr -d '\n')
  signerName: kubernetes.io/kube-apiserver-client
  usages:
  - client auth
EOF

cat <<EOF | kubectl apply -f -
apiVersion: certificates.k8s.io/v1
kind: CertificateSigningRequest
metadata:
  name: mike-csr
spec:
  request: $(cat mike.csr | base64 | tr -d '\n')
  signerName: kubernetes.io/kube-apiserver-client
  usages:
  - client auth
EOF

cat <<EOF | kubectl apply -f -
apiVersion: certificates.k8s.io/v1
kind: CertificateSigningRequest
metadata:
  name: john-csr
spec:
  request: $(cat john.csr | base64 | tr -d '\n')
  signerName: kubernetes.io/kube-apiserver-client
  usages:
  - client auth
EOF

# подтверждаем CSR
kubectl certificate approve bob-csr
kubectl certificate approve alice-csr
kubectl certificate approve mike-csr
kubectl certificate approve john-csr

# извлекаем сертификаты
kubectl get csr bob-csr -o jsonpath='{.status.certificate}' | base64 --decode > bob.crt
kubectl get csr alice-csr -o jsonpath='{.status.certificate}' | base64 --decode > alice.crt
kubectl get csr mike-csr -o jsonpath='{.status.certificate}' | base64 --decode > mike.crt
kubectl get csr john-csr -o jsonpath='{.status.certificate}' | base64 --decode > john.crt

# добавляем пользователей и контексты в Kubeconfig
kubectl config set-credentials bob --client-certificate=bob.crt --client-key=bob.key
kubectl config set-credentials alice --client-certificate=alice.crt --client-key=alice.key
kubectl config set-credentials mike --client-certificate=mike.crt --client-key=mike.key
kubectl config set-credentials john --client-certificate=john.crt --client-key=john.key
kubectl config set-context bob-context --cluster=minikube --user=bob
kubectl config set-context alice-context --cluster=minikube --user=alice
kubectl config set-context mike-context --cluster=minikube --user=mike
kubectl config set-context john-context --cluster=minikube --user=john
