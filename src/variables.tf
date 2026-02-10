variable "token" {
  type        = string
  description = "OAuth-token; https://cloud.yandex.ru/docs/iam/concepts/authorization/oauth-token"
}

variable "cloud_id" {
  type        = string
  description = "ID облака"
}

variable "folder_id" {
  type        = string
  description = "ID каталога"
}

variable "default_zone" {
  type    = string
  default = "ru-central1-a"
}

# ----------------------  Сети  ----------------------
variable "public_subnet_cidr" {
  type    = string
  default = "192.168.10.0/24"
}
variable "private_subnet_cidr" {
  type    = string
  default = "192.168.20.0/24"
}
variable "nat-instance-ip" {
  type    = string
  default = "192.168.10.254"
}
variable "public_subnet_name" {
  type    = string
  default = "public"
}
variable "private_subnet_name" {
  type    = string
  default = "private"
}

# ----------------------  Образы  --------------------
# Образ NAT-инстанса (Ubuntu 20.04 LTS) – указан в задании
variable "nat_image_id" {
  type    = string
  default = "fd80mrhj8fl2oe87o4e1"
}
# Образ обычных ВМ (можно менять)
variable "vm_image_family" {
  type    = string
  default = "ubuntu-2004-lts"
}

# ----------------------  SSH-ключи  ----------------
variable "ssh_public_key_path" {
  type    = string
  default = "./ed25519.pub"
}
variable "ssh_private_key_path" {
  type    = string
  default = "./ed25519"
}
