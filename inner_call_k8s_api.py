"""
参考: /0yxgithub/stable-diffusion-on-gcp-no-aliyun/最新版本的部署方式(首先看这个).txt  的第19点
在ubuntu的pod里面测试的，参考上面文件的第8点如何进入ubuntu的pod

conda activate sd_python310_20230907
pip install kubernetes==27.2.0

python inner_call_k8s_api.py  即可

# 获取GKE集群的公网的endpoint(也可以直接在web界面的gke控制台查看):
# gcloud container clusters describe 集群名称 --region us-central1 --format=json | jq .privateClusterConfig.publicEndpoint
# 例如 gcloud container clusters describe tf-gen-gke-c8c84f4c --region us-central1 --format=json | jq .privateClusterConfig.publicEndpoint
"""
from kubernetes import client, config
# from google.auth import compute_engine
# from google.cloud.container_v1 import ClusterManagerClient
from os import path
import requests
import yaml
import socket
import time
import base64
import json
import os


def get_access_token():
    METADATA_URL = 'http://metadata.google.internal/computeMetadata/v1/'
    METADATA_HEADERS = {'Metadata-Flavor': 'Google'}
    # 用kubectl获取有哪些服务账号
    # kubectl get serviceaccounts 或者 kubectl get serviceaccounts -A
    SERVICE_ACCOUNT = 'default'
    url = '{}instance/service-accounts/{}/token?scopes=https://www.googleapis.com/auth/cloud-platform'.format(
        METADATA_URL, SERVICE_ACCOUNT)
    # Request an access token from the metadata server.
    r = requests.get(url, headers=METADATA_HEADERS)
    r.raise_for_status()
    # Extract the access token from the response.
    try:
        access_token = r.json()['access_token']
        print("get access token success!")
    except Exception as e:
        print("fail to get access token!", e)
        return "fail"
    return access_token


def test_k8s_api(access_token):
    configuration = client.Configuration()
    # 获取GKE集群的公网的endpoint(也可以直接在web界面的gke控制台查看):
    # gcloud container clusters describe 集群名称 --region us-central1 --format=json | jq .privateClusterConfig.publicEndpoint
    # 例如 gcloud container clusters describe tf-gen-gke-c8c84f4c --region us-central1 --format=json | jq .privateClusterConfig.publicEndpoint
    #
    k8s_host = "34.72.33.93"
    configuration.host = "https://" + k8s_host + ":443"
    configuration.verify_ssl = False
    configuration.api_key = {"authorization": "Bearer " + access_token}
    client.Configuration.set_default(configuration)
    #
    crdclient = client.CustomObjectsApi()
    yxclient = client.CoreV1Api()
    #
    if 1:  # 看pod列表
        pod_list = yxclient.list_pod_for_all_namespaces(watch=False)
        print("pod list-----------------------------------")
        for pod in pod_list.items:
            print(pod.metadata.name, pod.status.pod_ip)
    if 1: # 看自定义对象列表，比如agones的gameserver列表
        # 看api的group命令： kubectl api-resources -o wide  过滤出某个group的api的命令: kubectl api-resources --api-group=""
        group = 'agones.dev'  # 'agones.dev' # str | the custom resource's group | kubectl api-resources -o wide
        # 看api的version命令： kubectl api-versions
        # kubectl get pods --all-namespaces -o custom-columns="NAMESPACE:.metadata.namespace,POD:.metadata.name,API_VERSION:.apiVersion"
        version = 'v1'  # str | the custom resource's version
        namespace = 'default'  # str | The custom resource's namespace
        resource_type = 'gameservers'  # str | the custom resource's plural name. For TPRs this would be lowercase plural kind. | kubectl api-resources -o wide
        # name = 'demo-allocate' # str | the custom object's name
        # body = None # object | The JSON schema of the Resource to patch.
        # print(help(crdclient.list_namespaced_custom_object))
        # 使用 CustomObjectsApi 获取 Pod 列表
        pod_list = crdclient.list_namespaced_custom_object(
            group=group,
            version=version,
            namespace=namespace,
            plural=resource_type
        )
        print("gameserver list-----------------------------------")
        for pod in pod_list.get("items", []):
            pod_name = pod["metadata"]["name"]
            pod_status = pod["status"]["state"]
            print(f"Pod Name: {pod_name}, Status: {pod_status}")
            # print(pod)
    if 0: # 删除一个gameserver名为sd-agones-fleet-5k8k6-5gd8c----测试成功---
        group = 'agones.dev'
        version = 'v1'
        namespace = 'default'
        resource_type = 'gameservers'
        game_server_name = 'sd-agones-fleet-5k8k6-5gd8c'

        try:
            # Use the CustomObjectsApi to delete the GameServer
            crdclient.delete_namespaced_custom_object(
                group=group,
                version=version,
                namespace=namespace,
                plural=resource_type,
                name=game_server_name,
                body=client.V1DeleteOptions()
            )
            print(f"Deleted GameServer: {game_server_name}")
        except client.rest.ApiException as e:
            if e.status == 404:
                print(f"GameServer {game_server_name} not found in namespace {namespace}")
            else:
                print(f"Failed to delete GameServer {game_server_name}: {e}")



if __name__ == "__main__":
    print("start-----------------------------------")
    access_token = get_access_token()
    print(access_token)
    test_k8s_api(access_token)
