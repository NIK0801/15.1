resource "yandex_compute_instance" "nat" {
  name        = "nat-instance"
  zone        = var.default_zone
  platform_id = "standard-v1"

  resources {
    cores  = 2
    memory = 2
  }

  boot_disk {
    initialize_params {
      image_id = var.nat_image_id
    }
  }

  network_interface {
    subnet_id  = yandex_vpc_subnet.public.id
    ip_address = var.nat-instance-ip # фиксированный внутренний IP
    nat        = true             # публичный (выходной) IP
  }

  metadata = {
    # Передаём скрипт cloud‑init, который включит форвардинг и добавит правило MASQUERADE.
    user-data = <<-EOF
                #cloud-config
                runcmd:
                  - [ sysctl, -w, net.ipv4.ip_forward=1 ]
                  - [ iptables, -t, nat, -A, POSTROUTING, -o, eth0, -j, MASQUERADE ]
                EOF
  }

}
