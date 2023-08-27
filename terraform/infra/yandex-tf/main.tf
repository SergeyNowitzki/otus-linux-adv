locals {
  ssh_key = "ubuntu:${file("YOUR_PATH_TO_THE_PUB_KEY")}" #e.g."~/.ssh/id_rsa_tf_lab.pub"
}

resource "yandex_vpc_network" "vpc" {
  # folder_id = var.folder_id
  name = var.vpc_name
}

resource "yandex_vpc_subnet" "subnet" {
  # folder_id = var.folder_id
  v4_cidr_blocks = var.subnet_cidrs
  zone           = var.zone
  name           = var.subnet_name
  network_id = yandex_vpc_network.vpc.id
}

resource "yandex_compute_instance" "instance" {
  name        = var.vm_name
  hostname    = var.vm_name
  platform_id = var.platform_id
  zone        = var.zone
  # folder_id   = var.folder_id
  resources {
    cores         = var.cpu
    memory        = var.memory
    core_fraction = var.core_fraction
  }

  boot_disk {
    initialize_params {
      image_id = var.image_id
      size     = var.disk
      type     = var.disk_type
    }
  }

  network_interface {
    subnet_id          = yandex_vpc_subnet.subnet.id
    nat                = var.nat
    ip_address         = var.internal_ip_address
    nat_ip_address     = var.nat_ip_address
  }

  metadata = {
    ssh-keys           = local.ssh_key
  }
  provisioner "remote-exec" {
    inline = ["sudo apt update", "sudo apt install python3 -y", "echo Done!"]

    connection {
      host        = self.network_interface[0].nat_ip_address
      type        = "ssh"
      user        = "ubuntu"
      private_key = file(var.ssh_pvt)
    }
  }
provisioner "local-exec" {
    command = "/bin/bash ../../../Scripts/ansible-nginx-exec-local.sh ${self.network_interface[0].nat_ip_address} ${var.ssh_pvt}"
    }
}