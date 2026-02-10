# Образ для обычных ВМ (Ubuntu 20.04 LTS) – берём по семейству
data "yandex_compute_image" "vm_image" {
  family = var.vm_image_family
}
