data "ct_config" "amazing_vm_ignition" {
  strict = true
  content = templatefile("butane/amazing-vm.yaml.tftpl", {
    ssh_admin_username   = "admin"
    ssh_admin_public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDytfbbDrd6G6EfOjq93qZ2+ND95/1/y9ly75EFcR3fj1gtqLG3LiFssyFkf79tamlE8+KgUWE8Kb4a8QqKEyX0vwdYytTHsa4q8ifaq2vy6APnYvGeXy6mVUWzpgT+yOK1UU9iq3s4dlS5WgQUHJ+10dbs8TWw/jgsqjKCJhUI/rT3lZg9yBZ+BSsux2aKZjs7g7+94qk1ZDVADtBs5jF34N6I2CCLy8DfjBsJ0arMdOrZS5TCyxM+FUDGqN/DMkA14907NRgqjxk5QOlLAsi/qN3g6ZRDx+nCMBUTC+ALxizaQeAZhELyMisi+TJbDGQoN7IJC8i/mz8KKmt/3cnJ christian@Fedora-WS"
    hostname             = "amazing-vm"
  })
}

resource "proxmox_virtual_environment_vm" "amazing_vm" {
  node_name   = "pve"
  name        = "amazing-vm"
  description = "Managed by OpenTofu"

  machine = "q35"

  # Since we're installing the guest agent in our Butane config,
  # we should enable it here for better integration with Proxmox
  agent {
    enabled = true
  }

  memory {
    dedicated = 4096
  }

  # Here we're referencing the file we uploaded before. Proxmox will
  # clone a new disk from it with the size we're defining.
  disk {
    interface    = "virtio0"
    datastore_id = "ISOs"
    file_id      = proxmox_virtual_environment_file.coreos_qcow2.id
    size         = 32
  }

  # We need a network connection so that we can install the guest agent
  network_device {
    bridge = "vmbr0"
  }

  kvm_arguments = "-fw_cfg 'name=opt/com.coreos/config,string=${replace(data.ct_config.amazing_vm_ignition.rendered, ",", ",,")}'"
}
