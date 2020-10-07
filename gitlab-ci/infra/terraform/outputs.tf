output "inventory" {
value = <<INVENTORY
{
  "_meta": {
  "hostvars": {}},
  "${yandex_compute_instance.gitlab-ci-vm.name}": {
    "hosts": ["${yandex_compute_instance.gitlab-ci-vm.network_interface.0.nat_ip_address}"],
    "vars": {}
    }
  }
  INVENTORY
}
