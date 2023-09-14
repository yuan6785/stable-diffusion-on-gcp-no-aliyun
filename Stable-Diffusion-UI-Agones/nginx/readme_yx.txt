#yx记录的打包步骤---参考/Users/yuanxiao/workspace/0yxgithub/Stable-Diffusion-on-GCP/yx部署过程记录.txt第七步

方法一(打包镜像的方式):
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

方法二(一个yaml的方式，不用打包镜像)---后期用这种了(放心用测试通过了)---重要，目前用的-----：
    全部创建命令-----
    --------修改lua文件，其他configmap的文件类似
    如果要调试 /0yxgithub/stable-diffusion-on-gcp-no-aliyun/Stable-Diffusion-UI-Agones/nginx/sd_onefile_yx.lua
    就将sd_onefile_yx.lua的内容复制到
    /0yxgithub/stable-diffusion-on-gcp-no-aliyun/Stable-Diffusion-UI-Agones/nginx/deployment_yx_onefile.yaml
    的configmap里面替换test_lua的内容即可。
    注意: 我修改的sd_onefile_yx.lua部分内容，后期需要用定时任务去实现，因为可能出现gs被sd内存占满，导致无法判断的情况，
    导致gs越来越多就不好了。
    --------
    cd /Users/yuanxiao/workspace/0yxgithub/stable-diffusion-on-gcp-no-aliyun/Stable-Diffusion-UI-Agones/nginx
    创建(创建前先删除):
        # 下面两种类型选一个即可，要么pod，要么deployment---这个yaml里面有configmap,记得删除的时候删除configmap
        kubectl apply -f deployment_yx_onefile.yaml

    删除:
        kubectl delete deployment stable-diffusion-nginx-deployment
        kubectl delete configmap stable-diffusion-nginx-deployment-configmap
    -------