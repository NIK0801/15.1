# ---------- Публичная ВМ (для проверки доступа в Интернет и как "шлюз") ----------
resource "yandex_compute_instance" "public_vm" {
  name        = "public-vm"
  zone        = var.default_zone
  platform_id = "standard-v1"

  resources {
    cores  = 2
    memory = 2
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.vm_image.id
    }
  }

  network_interface {
    subnet_id          = yandex_vpc_subnet.public.id
    nat                = true # публичный IP
    security_group_ids = [yandex_vpc_security_group.sg_public.id]
  }

  metadata = {
    ssh-keys = local.ssh_pub_key_formatted
  }

  depends_on = [yandex_compute_instance.nat] # чтобы NAT уже был готов
}

# ---------- Приватная ВМ ----------
resource "yandex_compute_instance" "private_vm" {
  name        = "private-vm"
  zone        = var.default_zone
  platform_id = "standard-v1"

  resources {
    cores  = 2
    memory = 2
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.vm_image.id
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.private.id
    # без NAT – публичный IP не будет
    security_group_ids = [yandex_vpc_security_group.sg_private.id]
  }

  metadata = {
    ssh-keys = local.ssh_pub_key_formatted
  }

  # Доступ к этой ВМ будем делать через bastion (public_vm)
  provisioner "remote-exec" {
    connection {
      type = "ssh"
      #host        = yandex_compute_instance.public_vm.network_interface[0].nat_ip_address
      user        = local.ssh_user
      private_key = file(var.ssh_private_key_path)

      # Прокси‑команда, чтобы попасть в приватную ВМ через bastion
      bastion_host        = yandex_compute_instance.public_vm.network_interface[0].nat_ip_address
      bastion_user        = local.ssh_user
      bastion_private_key = file(var.ssh_private_key_path)

      # IP приватной ВМ (изнутри сети)
      host = yandex_compute_instance.private_vm.network_interface[0].ip_address
    }

    inline = [
      "echo 'SUCCESS: подключились к private_vm через bastion!'"
    ]
  }

  depends_on = [yandex_compute_instance.public_vm]
}
