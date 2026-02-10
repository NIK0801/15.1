# SG для публичных ресурсов (NAT + публичная ВМ)
resource "yandex_vpc_security_group" "sg_public" {
  name       = "sg_public"
  network_id = yandex_vpc_network.develop.id
  folder_id  = var.folder_id

  # Входящие: SSH, HTTP, HTTPS от любого
  ingress {
    description    = "SSH from Internet"
    protocol       = "TCP"
    port           = 22
    v4_cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description    = "HTTP from Internet"
    protocol       = "TCP"
    port           = 80
    v4_cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description    = "HTTPS from Internet"
    protocol       = "TCP"
    port           = 443
    v4_cidr_blocks = ["0.0.0.0/0"]
  }

  # Исходящие – любой
  egress {
    description    = "All outbound"
    protocol       = "ANY"
    v4_cidr_blocks = ["0.0.0.0/0"]
  }
}

# SG для приватной подсети
resource "yandex_vpc_security_group" "sg_private" {
  name       = "sg_private"
  network_id = yandex_vpc_network.develop.id
  folder_id  = var.folder_id

  # Разрешаем SSH только от публичной подсети
  ingress {
    description    = "SSH from public subnet"
    protocol       = "TCP"
    port           = 22
    v4_cidr_blocks = [var.public_subnet_cidr]
  }

  # Исходящие – любой (чтобы NAT мог отправлять)
  egress {
    description    = "All outbound"
    protocol       = "ANY"
    v4_cidr_blocks = ["0.0.0.0/0"]
  }
}
