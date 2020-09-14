output "external_ip_address_docker" {
  value = yandex_compute_instance.docker-host[*].network_interface.0.nat_ip_address
}
