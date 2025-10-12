module "server1" {
  source = "./modules/vm"

  name         = "proxy"
  memory       = 1024
  vcpu         = 1
  pool_name    = var.libvirt_pool_name
  pool_path    = var.libvirt_pool_path
  base_image   = "debian13-base.qcow2"

  networks = [
    { network_name = "nat-dhcp", wait_for_lease = true},
    { network_name = "muy-aislada" }
  ]

    user_data      = "${path.module}/cloud-init/server1/user-data.yaml"
  network_config = "${path.module}/cloud-init/server1/network-config.yaml"

  depends_on = [
    libvirt_network.nat-dhcp,
    libvirt_network.muy-aislada
  ]
}

# Ejemplo de VM sin network_config
module "server2" {
  source = "./modules/vm"

  name         = "backend"
  memory       = 1024
  vcpu         = 1
  pool_name    = var.libvirt_pool_name
  pool_path    = var.libvirt_pool_path
  base_image   = "debian13-base.qcow2"

 networks = [
    { network_name = "nat-dhcp", wait_for_lease = true},
    { network_name = "muy-aislada" }
  ]

  user_data = "${path.module}/cloud-init/server2/user-data.yaml"
  network_config = "${path.module}/cloud-init/server2/network-config.yaml"

  depends_on = [
    libvirt_network.nat-dhcp,
    libvirt_network.muy-aislada
  ]
}


resource "null_resource" "copy_files_backend" {
  depends_on = [module.server2]

  # Conexión SSH común para todos los provisioners
  connection {
    type        = "ssh"
    user        = "debian"
    agent       = true
    host        = module.server2.vm_info.ips[0]
  }

  # Copiar carpeta completa local al /tmp del servidor
  provisioner "file" {
    source      = "ficheros"
    destination = "/tmp"
  }

}
