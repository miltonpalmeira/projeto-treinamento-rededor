variable "name" {}
variable "handler" {}
variable "role_arn" {}
variable "filename" {}
variable "env_vars" {
  type    = map(string)
  default = {}
}