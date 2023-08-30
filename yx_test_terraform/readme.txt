测试terraform在不同模块之间变量传值

测试之前删除terraform.tfstate, .terraform文件夹, .terraform.lock.hcl文件

terraform init 

# terraform apply  # 全部运行


# 部署资源
terraform apply --auto-approve -target="module.module_a";terraform apply --auto-approve -target="module.module_b";


# 销毁资源
terraform destroy --auto-approve -target="module.module_b";terraform destroy --auto-approve -target="module.module_a";