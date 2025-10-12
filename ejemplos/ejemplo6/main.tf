module "server1" {
  source = "./modules/vm"

  name         = "server1"
  memory       = 1024
  vcpu         = 2
  pool_name    = var.libvirt_pool_name
  pool_path    = var.libvirt_pool_path
  base_image   = "debian13-base.qcow2"

  networks = [
    { network_name = "nat-dhcp", wait_for_lease = true},
    { network_name = "muy-aislada" }
  ]

  disks = [
    { name = "data", size = 5 * 1024 * 1024 * 1024 }
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

  name         = "server2"
  memory       = 1024
  vcpu         = 2
  pool_name    = var.libvirt_pool_name
  pool_path    = var.libvirt_pool_path
  base_image   = "ubuntu2404-base.qcow2"

  networks = [{ network_name = "muy-aislada"}]

  user_data = "${path.module}/cloud-init/server2/user-data.yaml"
  network_config = "${path.module}/cloud-init/server2/network-config.yaml"

  depends_on = [libvirt_network.muy-aislada]
}
