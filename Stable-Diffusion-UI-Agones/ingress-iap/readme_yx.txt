参考: https://cloud.google.com/kubernetes-engine/docs/how-to/managed-certs?hl=zh-cn#gcloud

cd  Stable-Diffusion-UI-Agones/ingress-iap
# 更换域名的步骤:
修改ingress_yx.yaml的 kubernetes.io/ingress.global-static-ip-name 为 静态ip名称
修改managed-cert-yx.yaml的 domains为你的域名，支持多个

# 然后
kubectl apply -f ./ingress-iap/managed-cert-yx.yaml
kubectl apply -f ./ingress-iap/backendconfig.yaml
kubectl apply -f ./ingress-iap/service.yaml
kubectl apply -f ./ingress-iap/ingress_yx.yaml  # ingress这个最好先删除再运行这个命令

# 查看证书配置是否完成的命令---
kubectl describe managedcertificate managed-cert

# 有时候报证书错误需要等60分钟
当： Certificate Status:  Active # 就可以了
Certificate Status:  Provisioning  # 表示正在申请证书 

