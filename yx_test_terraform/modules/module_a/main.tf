variable "variable_a" {
  description = "test var a"
  type        = string
}

# # 必须放一个资源才会有输出
# resource "random_id" "tf_subfix" {
#   byte_length = 4
# }

output "output_from_module_a" {
  value = var.variable_a
}

output "output_from_module_a1" {
  value = "fdafdafdas"
}