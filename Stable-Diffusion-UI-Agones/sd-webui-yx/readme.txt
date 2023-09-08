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


2. 调试镜像
    获取gke集群的凭证
    source  ~/.zshrc_google_cloud  即可用gcloud命令
    ------------------------------------
    GKE_CLUSTER_NAME=tf-gen-gke-c8c84f4c
    REGION=us-central1
    gcloud container clusters get-credentials ${GKE_CLUSTER_NAME} --region ${REGION}
    ------------------------------------
    f*b**1**

    cd  /0yxgithub/stable-diffusion-on-gcp-no-aliyun/Stable-Diffusion-UI-Agones/sd-webui-yx  # 必须是这个目录
    kubectl apply -f sd_pod_debug.yaml
    # 进入pod进行调试即可
    kubectl  exec -it   -n default $(kubectl get pods  -n default  |grep sdwebui-debug |awk '{print $1}' |awk NR==1)   /bin/bash
    # 进入gs多个容器的节点方法
    # kubectl  exec -it   -n default sd-agones-fleet-jngqm-ljtxq  -c stable-diffusion-webui  /bin/bash
    # 调试完成一定记得删除pod
    kubectl delete pod sdwebui-debug
