variable "prefix" {
  default="netframe"
}

variable "admin_username" {
  default = "testadmin"
}

variable "runner_token" {
  type = string
  description = "The Github actions self-hosted runner registration token"
}