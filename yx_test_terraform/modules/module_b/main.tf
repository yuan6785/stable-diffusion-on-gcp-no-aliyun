variable "variable_b" {}

# # 必须放一个资源才会有输出
# resource "random_id" "tf_subfix" {
#   byte_length = 4
# }

output "output_from_module_b" {
  value = var.variable_b
}
