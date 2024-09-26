curl -s -v --header "Authorization: Bearer $(cat /var/run/secrets/kubernetes.io/serviceaccount/token)" --header "Accept: application/json" --cacert /var/run/secrets/kubernetes.io/serviceaccount/ca.crt https://kubernetes.default.svc/api/v1/namespaces/default/pods/sm-0

