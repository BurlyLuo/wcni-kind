# 1. Test allow fqdn: https://api.gitee.com
echo "kubectl exec mediabot -- curl -I -s --max-time 2 https://api.gitee.com | head -1"
kubectl exec mediabot -- curl -I -s --max-time 2 https://api.gitee.com | head -1

# 2. Test not-allow fqdn: http://api.gitee.com
echo "kubectl exec mediabot -- curl -I -s --max-time 2 http://api.gitee.com | head -1"
kubectl exec mediabot -- curl -I -s --max-time 2 http://api.gitee.com | head -1
