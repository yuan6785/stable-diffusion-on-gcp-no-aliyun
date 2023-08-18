# 查看证书配置是否完成的命令---
kubectl describe managedcertificate managed-cert

# 有时候报证书错误需要等60分钟
# 当： Certificate Status:  Active 就可以了

参考: https://cloud.google.com/kubernetes-engine/docs/how-to/managed-certs?hl=zh-cn#gcloud