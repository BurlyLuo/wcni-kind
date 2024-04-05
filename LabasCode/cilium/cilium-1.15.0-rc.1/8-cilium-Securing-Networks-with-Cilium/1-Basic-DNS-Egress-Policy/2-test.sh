# 1. Test allow fqdn: gitee.com
echo "kubectl exec mediabot -- curl -I -s https://gitee.com | head -1"
kubectl exec mediabot -- curl -I -s https://gitee.com | head -1

# 2. Test not-allow fqdn: support.gitee.com
echo "kubectl exec mediabot -- curl -I -s --max-time 5 https://support.gitee.com | head -1"
kubectl exec mediabot -- curl -I -s --max-time 5 https://support.gitee.com | head -1

