# Формат для метаданных Yandex: "login:ssh‑public‑key"
locals {
  ssh_user              = "ubuntu"
  ssh_pub_key_content   = file(var.ssh_public_key_path)
  ssh_pub_key_formatted = "${local.ssh_user}:${local.ssh_pub_key_content}"
}
