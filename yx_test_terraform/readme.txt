测试terraform在不同模块之间变量传值

测试之前删除terraform.tfstate, terraform.tfstate.backup, .terraform文件夹, .terraform.lock.hcl文件

rm -rf terraform.tfstate .terraform .terraform.lock.hcl  terraform.tfstate.backup

terraform init 

# terraform apply  # 全部运行


# 部署资源
terraform apply --auto-approve -target="module.module_a";terraform apply --auto-approve -target="module.module_b";


# 销毁资源
terraform destroy --auto-approve -target="module.module_b";terraform destroy --auto-approve -target="module.module_a";


# 注意:
这个实例不用在output输出里面看，需要在执行过程中看，因为我用了null_resource的local-exec进行调试，所以需要在执行过程中看，不然看不到结果
这里可以看到尽管没有output的输出，但是echo中还是能看到变量的传递，具体怎么传递的我还真不知道，但是可以看到是可以传递的