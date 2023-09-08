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