echo ---------start-------$(date +"%Y-%m-%d %H:%M:%S")---------------
echo ---------start ln base-------$(date +"%Y-%m-%d %H:%M:%S")---------------
for dir in ControlNet  hypernetworks  Lora  Stable-diffusion  VAE BLIP torch_deepdanbooru; do if [ ! -L "/opt/stable-diffusion-webui/models/$dir" ]; then rm -rf  /opt/stable-diffusion-webui/models/$dir; ln -s /yuanxiao_root_nfs/sdwebui_public/public/models/$dir  /opt/stable-diffusion-webui/models/; fi; done
for dir in embeddings  localizations  outputs  samples  scripts; do if [ ! -L "/opt/stable-diffusion-webui/$dir" ]; then rm -rf  /opt/stable-diffusion-webui/$dir; ln -s /yuanxiao_root_nfs/sdwebui_public/public/$dir  /opt/stable-diffusion-webui/; fi; done
# echo ---------start ln additional networks-------$(date +"%Y-%m-%d %H:%M:%S")---------------
# rm -rf /opt/stable-diffusion-webui/extensions/sd-webui-additional-networks/models/lora/*
# ln -s /yuanxiao_root_nfs/sdwebui_public/public/models/Lora  /opt/stable-diffusion-webui/extensions/sd-webui-additional-networks/models/lora/
echo ---------start launch pre-------$(date +"%Y-%m-%d %H:%M:%S")---------------
echo "yx test 1111">/var/log/sdwebui.log
sleep 2
rm -rf /opt/stable-diffusion-webui/styles.csv
ln -s /yuanxiao_root_nfs/sdwebui_public/public/styles/styles.csv /opt/stable-diffusion-webui/styles.csv
echo ---------start launch-------$(date +"%Y-%m-%d %H:%M:%S")---------------
cd /opt/stable-diffusion-webui
# 为什么加这句参考 0yxgithub/Stable-Diffusion-on-GCP/Stable-Diffusion-UI-Novel/docker_inference/aliyun_func_libo/Dockerfile.aliyun.libo.20230713
# 下面用dockerfile安装的python路径，不要用filestore的公共路径的python(这里和阿里云函数不一样)
/opt/miniconda3/bin/conda init;chmod +x ~/.bashrc;. ~/.bashrc;eval "$(/opt/miniconda3/bin/conda shell.bash hook)";conda activate py310_sdwebui;python -c "import sys; print(sys.executable)"
# /opt/miniconda3/envs/py310_sdwebui/bin/python -m  http.server 7860   ----可以加--share让pod可以公网访问
# /opt/miniconda3/envs/py310_sdwebui/bin/python -u launch.py --port 7860 --listen --xformers --medvram --share --lyco-debug --lyco-patch-lora --lyco-dir ./models/Lora --skip-prepare-environment --api 2>&1 | tee /var/log/sdwebui.log
# 将sdwebui放到supervisor中使用
echo ---------start launch cmd-------$(date +"%Y-%m-%d %H:%M:%S")---------------
cd /opt
/usr/sbin/nginx -c /etc/nginx/nginx.conf
rm -rf /var/run/supervisor.sock;/usr/bin/supervisord -c /etc/supervisord.conf
while true;do date;sleep 86400;done
echo ---------end-------'