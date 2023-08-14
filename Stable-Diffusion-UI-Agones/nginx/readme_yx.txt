#yx记录的打包步骤---参考/Users/yuanxiao/workspace/0yxgithub/Stable-Diffusion-on-GCP/yx部署过程记录.txt第七步

REGION=us-central1
PROJECT_ID=happyaigc
BUILD_REGIST=sd-repository-2b6bae98

REDIS_IP=$(gcloud redis instances describe sd-agones-cache-2b6bae98 --region ${REGION} --format=json 2>/dev/null | jq .host)
sed "s@\"\${REDIS_HOST}\"@${REDIS_IP}@g" sd.lua > _tmp
mv _tmp sd_new.lua

REGION=us-central1
PROJECT_ID=happyaigc
gcloud auth configure-docker ${REGION}-docker.pkg.dev
gcloud builds submit --region=${REGION} . --config=cloudbuild.yaml





