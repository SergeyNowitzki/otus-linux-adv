resource "proxmox_vm_qemu" "srv-test" {
  count = 1
  name = "srv-test-${count.index + 1}"
  vmid = "20${count.index + 1}"
  target_node = var.proxmox_node
  clone = var.cloudinit_template_name
  agent = 1
  os_type = "cloud-init"
  cores = 1
  sockets = 1
  cpu = "host"
  memory = 2048
  scsihw = "virtio-scsi-pci"
  bootdisk = "scsi0"
  kvm = false
  onboot = true

  disk {
    slot = 0
    size = "20G"
    type = "scsi"
    storage = "local"
    iothread = 1
  }

  network {
    model = "virtio"
    bridge = "vmbr0"
  }

  lifecycle {
    ignore_changes = [
      network,
    ]
  }

  ipconfig0 = "ip=192.168.99.20${count.index + 1}/24,gw=192.168.99.254"
  nameserver = "192.168.99.100"

  sshkeys = <<EOF
  ${var.ssh_key}
  EOF
}
