output "public_subnet_id" {
  description = "ID публичной подсети"
  value       = yandex_vpc_subnet.public.id
}

output "private_subnet_id" {
  description = "ID приватной подсети"
  value       = yandex_vpc_subnet.private.id
}

output "nat_instance_internal_ip" {
  description = "Внутренний IP NAT-инстанса"
  value       = yandex_compute_instance.nat.network_interface[0].ip_address
}

output "nat_instance_external_ip" {
  description = "Публичный IP NAT-инстанса"
  value       = yandex_compute_instance.nat.network_interface[0].nat_ip_address
}

output "public_vm_external_ip" {
  description = "Публичный IP публичной ВМ"
  value       = yandex_compute_instance.public_vm.network_interface[0].nat_ip_address
}

output "private_vm_internal_ip" {
  description = "Внутренний IP приватной ВМ"
  value       = yandex_compute_instance.private_vm.network_interface[0].ip_address
}
