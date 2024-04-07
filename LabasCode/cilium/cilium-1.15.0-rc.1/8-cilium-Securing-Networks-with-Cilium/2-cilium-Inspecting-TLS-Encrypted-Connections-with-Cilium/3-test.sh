# 1. Check cilium ds pod which at test_pod node
test_pod_node=$(kubectl get pods -owide | grep mediabot | awk -F " " '{print $7}')
cilium_pod=$(kubectl -nkube-system get pods -o wide | egrep 'cilium-[[:alnum:]]+ ' | grep -w $test_pod_node | awk -F " " '{print $1}')

kubectl -nkube-system exec -it $cilium_pod -- cilium-dbg monitor -t l7 | tee TLS_Inspection.YAML &

# 2. Make a test
kubectl exec -it mediabot -- curl -sL 'https://artii.herokuapp.com/fonts_list'
kubectl exec -it mediabot -- curl -sL 'https://artii.herokuapp.com/make?text=cilium&font=univers'

# 3. Verify the logical
cat TLS_Inspection.YAML | grep "https://artii.herokuapp.com/fonts_list => 200"

# 4. kill kubectl
killall -9 kubectl
