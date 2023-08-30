variable "variable_to_pass" {
  default = "Hello from Module A"
}

module "module_a" {
  source = "./modules/module_a"
  variable_a = var.variable_to_pass
}

module "module_b" {
  source = "./modules/module_b"
  variable_b = module.module_a.output_from_module_a
}

# # 运行 terraform apply 后，会输出如下内容：
# output "test_main_var_output_a" {
#   value       = module.module_a.output_from_module_a
#   description = "test main var output"
# }

# output "test_main_var_output_b" {
#   value       = module.module_b.output_from_module_b
#   description = "test main var output"
# }

