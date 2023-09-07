用tf部署完成后的二次修改


gcloud config set project happyaigc # 认证

cd  Stable-Diffusion-UI-Agones/nginx  # 必须是这个目录

# 修改环境变量
REGION=us-central1
PROJECT_ID=happyaigc
BUILD_REGIST=sd-repository-88d93bc5
REDIS_IP=$(gcloud redis instances describe sd-agones-cache-88d93bc5 --region ${REGION} --format=json 2>/dev/null | jq .host)

sed "s@\"\${REDIS_HOST}\"@${REDIS_IP}@g" sd.lua > _tmp
mv _tmp sd_new.lua

# 修改cloudbuild.yaml的镜像标签----记得修改cloudbuild.yaml的docker地址和版本---
gcloud auth configure-docker ${REGION}-docker.pkg.dev
gcloud builds submit --region=${REGION} . --config=cloudbuild.yaml


# 重新部署(修改deployment_yx.yaml里面的镜像tag)
kubectl apply -f deployment_yx.yaml

# 报错的话，还原到最初的版本(修改deployment_yx.yaml里面的镜像tag)
kubectl apply -f deployment_yx_old.yaml

例如进入ubuntu清空redis 可以强制重启sd