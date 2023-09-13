参考: https://cloud.google.com/kubernetes-engine/docs/how-to/managed-certs?hl=zh-cn#gcloud

cd  Stable-Diffusion-UI-Agones/ingress-iap
# 更换域名的步骤:
修改ingress_yx.yaml的 kubernetes.io/ingress.global-static-ip-name 为 静态ip名称
修改managed-cert-yx.yaml的 domains为你的域名，支持多个,这些域名必须预先配置A记录解析到静态ip，先要能解析成功，才能申请证书成功;
特别是修改域名对应的ip，要等ip全部生效才能申请证书成功，可以用阿里云 https://boce.aliyun.com/detect/http  来检测域名是否全部生效了。

# 然后
kubectl delete ManagedCertificate  managed-cert
kubectl apply -f ./ingress-iap/managed-cert-yx.yaml
#kubectl apply -f ./ingress-iap/backendconfig.yaml
#kubectl apply -f ./ingress-iap/service.yaml
kubectl apply -f ./ingress-iap/ingress_yx.yaml  # 这个如果没有修改静态ip，可以不执行这个命令; 如果需要修改，ingress这个最好先删除再运行这个命令。

# 查看证书配置是否完成的命令---
kubectl describe managedcertificate managed-cert

# 有时候报【证书类型错误】【ssl_type_xxx】的错误需要等60分钟
当： Certificate Status:  Active # 就可以了, 有时候ACTIVE都还需要等待半小时才能用，文档说 负载均衡器可能需要再过 30 分钟之后才能使用它
Certificate Status:  Provisioning  # 表示正在申请证书 

也可以在[gke]-->[service 和 ingerss]-->[ingress, 点进去一个ingerss]------>[负载均衡器,  点进去]----->[https证书, 点击去查看即可]




后期其他参考: 

    不带iap认证的ingress(参考yx-clean-ingerss):
        修改backendconfig.yaml  
        iap:
            enabled: false



            
    保留iap认证的， 新建不带iap认证的ingress(参考yx-clean-ingerss):
        0. 新建ip addresses, 选择静态ip
        1. 首先新建一个不带iap的service.yaml, 制定一个自定义nginx的pod，重写nginx的sd.lua
        2. 然后新建一个不带iap的ingress.yaml（选择第0步的ip和第2步的service）


