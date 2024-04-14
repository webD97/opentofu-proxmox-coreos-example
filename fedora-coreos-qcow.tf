resource "null_resource" "coreos_qcow2" {
  provisioner "local-exec" {
    command = "mv $(coreos-installer download -p qemu -f qcow2.xz -s stable -a x86_64 -d) fedora-coreos.qcow2.img"
  }

  provisioner "local-exec" {
    when    = destroy
    command = "rm -f fedora-coreos.qcow2.img"
  }
}

resource "proxmox_virtual_environment_file" "coreos_qcow2" {
  content_type = "iso"
  datastore_id = "local"
  node_name    = "pve"

  depends_on = [null_resource.coreos_qcow2]

  source_file {
    path = "fedora-coreos.qcow2.img"
  }
}
