resource "yandex_vpc_route_table" "nat-route-table" {
  network_id = yandex_vpc_network.develop.id

  static_route {
    destination_prefix = "0.0.0.0/0"
    next_hop_address   = var.nat-instance-ip
  }
}
