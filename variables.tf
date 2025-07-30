variable "region" {
  default = "us-east-1"
}

variable "ami_id" {
  default = "ami-0150ccaf51ab55a51"
}

variable "key_name" {
  description = "Nombre de la clave SSH existente en AWS"
  type        = string
}
