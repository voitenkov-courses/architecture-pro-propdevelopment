# Аудит активности пользователей и обнаружение инцидентов

## Включение политик безопасности

minikube start \
  --extra-config=apiserver.audit-policy-file=/etc/ssl/certs/audit-policy.yaml \
  --extra-config=apiserver.audit-log-path=/etc/ssl/certs/audit.log 

## Результаты выпонения задания

[Отчет по выявленным событиям](ANALYSIS.md)  
[Выборка подозрительных событий](audit-extract.json)  
[Скрипт фильтрации](select-events.sh)