#/bin/bash
set -v
#kubectl apply -f https://raw.githubusercontent.com/kubevela/kubevela/master/docs/examples/vela-app.yaml

cat <<EOF| kubectl apply -f -
apiVersion: core.oam.dev/v1beta1
kind: Application
metadata:
  name: first-vela-app
spec:
  components:
    - name: express-server
      type: webservice
      properties:
        image: crccheck/hello-world
        port: 8000
      traits:
        - type: ingress-1-20
          properties:
            domain: testsvc.example.com
            http:
              "/": 8000
EOF

# Test:

date
lb_ip=`kubectl -nsandbox get svc --no-headers | grep ingress-nginx-controller | grep LoadBalancer | awk -F  " " '{print $4}'`
curl -H "Host:testsvc.example.com" http://$lb_ip/
