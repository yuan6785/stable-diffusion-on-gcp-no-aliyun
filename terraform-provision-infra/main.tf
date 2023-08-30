# Copyright 2023 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.


locals {
  project_id          = "happyaigc"
  oauth_client_id     = "972449351989-7nnen6jqnrd8im4ejcbj1p64fltpsurj.apps.googleusercontent.com"
  oauth_client_secret = "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"
  sd_webui_domain     = "sd.agones.163py.com" # "sd.agones.163py.com" "sd.agones.playdayy.cn"
  region              = "us-central1"
  filestore_zone      = "us-central1-f" # Filestore location must be same region or zone with gke
  cluster_location    = "us-central1-f" # GKE Cluster location  # us-central1 us-central1-f
  node_machine_type   = "custom-12-49152-ext"
  accelerator_type    = "nvidia-tesla-t4" # Available accelerator_type from gcloud compute accelerator-types list --format='csv(zone,name)'
  gke_num_nodes       = 2   # 这里设置的是gpu节点池的节点数量，默认节点数量在terraform-provision-infra/modules/agones/gcp-res/main.tf的default_nodepool里面设置
  # add by yx
  default_nodepool_name = "default-pool"
}

#[Agones version]

module "agones_gcp_res" {
  source                          = "./modules/agones/gcp-res"
  project_id                      = local.project_id
  region                          = local.region
  filestore_zone                  = local.filestore_zone
  cluster_location                = local.cluster_location
  node_machine_type               = local.node_machine_type
  accelerator_type                = local.accelerator_type
  gke_num_nodes                   = local.gke_num_nodes
  cloudfunctions_source_code_path = "../Stable-Diffusion-UI-Agones/cloud-function/"
  # add by yx
  default_nodepool_name           = local.default_nodepool_name
}

module "agones_build_image" {
  source            = "./modules/agones/cloud-build"
  artifact_registry = module.agones_gcp_res.artifactregistry_url
}

module "helm_agones" {
  source               = "./modules/agones/helm-agones"
  project_id           = local.project_id
  gke_cluster_name     = module.agones_gcp_res.kubernetes_cluster_name
  gke_cluster_location = module.agones_gcp_res.gke_location
  gke_cluster_nodepool = module.agones_gcp_res.gpu_nodepool_name
  #add by yx
  default_nodepool_name= module.agones_gcp_res.default_nodepool_name
  #add by yx
  gpu_nodepool_name    =  module.agones_gcp_res.gpu_nodepool_name
}

module "agones_k8s_res" {
  source                             = "./modules/agones/k8s-res"
  project_id                         = local.project_id
  oauth_client_id                    = local.oauth_client_id
  oauth_client_secret                = local.oauth_client_secret
  sd_webui_domain                    = local.sd_webui_domain
  gke_cluster_name                   = module.agones_gcp_res.kubernetes_cluster_name
  gke_cluster_location               = module.agones_gcp_res.gke_location
  gke_cluster_nodepool               = module.agones_gcp_res.gpu_nodepool_name
  google_filestore_reserved_ip_range = module.agones_gcp_res.google_filestore_reserved_ip_range
  webui_address_name                 = module.agones_gcp_res.webui_address_name
  # add by yx
  default_nodepool_name              = module.agones_gcp_res.default_nodepool_name
  nginx_image_url                    = module.agones_build_image.nginx_image
  webui_image_url                    = module.agones_build_image.webui_image
  game_server_image_url              = module.agones_build_image.game_server_image
}

output "webui_ingress_address" {
  value       = module.agones_gcp_res.webui_address
  description = "webui ip address for ingress"
}

#[Agones version]#


#[GKE version start]#

#module "nonagones_gcp_res" {
#  source            = "./modules/nonagones/gcp-res"
#  project_id        = local.project_id
#  region            = local.region
#  filestore_zone    = local.filestore_zone
#  cluster_location  = local.cluster_location
#  node_machine_type = local.node_machine_type
#  accelerator_type  = local.accelerator_type
#  gke_num_nodes     = local.gke_num_nodes
#}
#
#module "nonagones_build_image" {
#  source            = "./modules/nonagones/cloud-build"
#  artifact_registry = module.nonagones_gcp_res.artifactregistry_url
#}
#
#module "nonagones_k8s_res" {
#  source                             = "./modules/nonagones/k8s-res"
#  project_id                         = local.project_id
#  gke_cluster_name                   = module.nonagones_gcp_res.kubernetes_cluster_name
#  gke_cluster_location               = local.cluster_location
#  gke_cluster_nodepool               = module.nonagones_gcp_res.gpu_nodepool_name
#  google_filestore_reserved_ip_range = module.nonagones_gcp_res.google_filestore_reserved_ip_range
#  webui_image_url                    = module.nonagones_build_image.webui_image
#}

#[GKE version ]