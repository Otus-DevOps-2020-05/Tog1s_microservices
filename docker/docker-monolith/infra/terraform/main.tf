provider "yandex" {
  service_account_key_file = var.service_account_key_file
  cloud_id                 = var.cloud_id
  folder_id                = var.folder_id
  zone                     = var.zone
}

resource "yandex_compute_instance" "docker-host" {

  count   = var.instance_count
  name    = "docker-host${count.index + 1}"

  resources {
    cores  = 2
    memory = 2
  }

  boot_disk {
    initialize_params {
      image_id = var.image_id
      type     = "network-ssd"
    }
  }

  network_interface {
    subnet_id = var.subnet_id
    nat       = true
  }

  metadata = {
    ssh-keys = "ubuntu:${file(var.public_key_path)}"
  }

#   connection {
#     type  = "ssh"
#     host  = self.network_interface.0.nat_ip_address
#     user  = "ubuntu"
#     agent = false
#     private_key = file(var.private_key_path)
#   }

#   provisioner "remote-exec" {
#     inline = [
#       "sudo docker run --name reddit -d -p 9292:9292 tog1s/otus-reddit:1.0",
#     ]
#   }
}
