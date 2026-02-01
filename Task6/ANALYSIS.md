# Отчёт по результатам анализа Kubernetes Audit Log

## Подозрительные события

1. Доступ к секретам:
   - Кто: "username": "system:serviceaccount:secure-ops:monitoring"
   - Где: "namespace": "kube-system"
   - Почему подозрительно: чтение секретов в неймспейсе kube-system подозрительным Service Account

2. Привилегированные поды:
   - Кто: "username": "minikube-user"
   - Комментарий: запуск привилегированных подов - угроза безопасности для кластера

3. Использование kubectl exec в чужом поде:
   - Кто: "username": "minikube-user"
   - Что делал: "requestURI": "/api/v1/namespaces/kube-system/pods/coredns-66bc5c9577-bzszf/exec?command=cat&command=%2Fetc%2Fresolv.conf&container=coredns&stderr=true&stdout=true"

4. Создание RoleBinding с правами cluster-admin:
   - Кто: "username": "minikube-user"
   - К чему привело: выданы права cluster-admin для подозрительного Service Account

5. Удаление audit-policy.yaml:
   - Кто: ...
   - Возможные последствия: ...
   - Комментарий: Команда `kubectl delete -f /etc/kubernetes/audit-policy.yaml --as=admin` не удалит ни конфигурационный файл политики, ни саму политику, в логах ничего полезного не будет. Kind: Policy из apiVersion: audit.k8s.io/v1 не является ресурсом кубернетес, с которым можно работать через kubectl. Для того, чтобы включить или отключить логи аудита, надо перезапустить kube-apiserver с новыми параметрами. 

## Вывод

Настройка политик аудита позволяет отслеживать события нарушения безопасности, однако, помимо аудита необходимо внедрение активных мер по информационной безопасности, таких как сетевые политики, Pod Security Admission, политики безопасности, например с использованием Kyverno и т.д. 
