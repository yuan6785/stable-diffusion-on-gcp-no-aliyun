用tf部署完成后的二次修改

1. 打包镜像
    gcloud config set project happyaigc # 认证

    cd  /0yxgithub/stable-diffusion-on-gcp-no-aliyun/Stable-Diffusion-UI-Agones/sd-webui-yx  # 必须是这个目录

    # 修改环境变量
    REGION=us-central1
    PROJECT_ID=happyaigc
    BUILD_REGIST=sd-repository-c8c84f4c

    # 修改cloudbuild.yaml的镜像标签----记得修改cloudbuild.yaml的docker地址和版本---
    gcloud auth configure-docker ${REGION}-docker.pkg.dev
    gcloud builds submit --region=${REGION} . --config=cloudbuild.yaml


2. 调试镜像(如果肯定镜像是对的,可以跳过这一步)
    获取gke集群的凭证
    source  ~/.zshrc_google_cloud  即可用gcloud命令
    ------------------------------------
    GKE_CLUSTER_NAME=tf-gen-gke-c8c84f4c
    REGION=us-central1
    gcloud container clusters get-credentials ${GKE_CLUSTER_NAME} --region ${REGION}
    ------------------------------------
    f*b**1**

    cd  /0yxgithub/stable-diffusion-on-gcp-no-aliyun/Stable-Diffusion-UI-Agones/sd-webui-yx  # 必须是这个目录
    kubectl apply -f sd_pod_debug.yaml  # 记得修改sd_pod_debug.yaml的镜像地址和版本为第一步打包的镜像--重要--
    # 进入pod进行调试即可
    kubectl  exec -it   -n default $(kubectl get pods  -n default  |grep sdwebui-debug |awk '{print $1}' |awk NR==1)   /bin/bash
    # 进入gs多个容器的节点方法
    # kubectl  exec -it   -n default sd-agones-fleet-jngqm-ljtxq  -c stable-diffusion-webui  /bin/bash
    # 调试完成一定记得删除pod
    kubectl delete pod sdwebui-debug


特别注意:
    dockerfile最后安装完成我修改了一些python包的版本，以兼容插件能用起来，后面版本修复后，可以改回来
    1. 参考 https://github.com/jexom/sd-webui-depth-lib/issues/36 修复了插件的问题
       我的解决方法是在dockerfile里面gradio_client==0.5.0 降级到 gradio_client==0.2.7
       后期如果gradio_client的bug修复，需要恢复最高版本，否则怕影响其他插件和sdwebui的使用