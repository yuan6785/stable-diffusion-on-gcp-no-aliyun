#yx记录的打包步骤---参考/Users/yuanxiao/workspace/0yxgithub/Stable-Diffusion-on-GCP/yx部署过程记录.txt第七步

gcloud config set project happyaigc # 认证

REGION=us-central1
PROJECT_ID=happyaigc
BUILD_REGIST=sd-repository-2b6bae98
REDIS_IP=$(gcloud redis instances describe sd-agones-cache-2b6bae98 --region ${REGION} --format=json 2>/dev/null | jq .host)

sed "s@\"\${REDIS_HOST}\"@${REDIS_IP}@g" sd.lua > _tmp
mv _tmp sd_new.lua

# 修改cloudbuild.yaml的镜像标签
gcloud auth configure-docker ${REGION}-docker.pkg.dev
gcloud builds submit --region=${REGION} . --config=cloudbuild.yaml


# 重新部署(修改deployment_yx.yaml里面的镜像tag)
kubectl apply -f deployment_yx.yaml

# 报错的话，还原到最初的版本
kubectl apply -f deployment_yx_old.yaml

