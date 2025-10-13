# Clon ligero (backing store)
# El disco resultante apunta al volumen base y solo guarda cambios diferenciales
resource "libvirt_volume" "server1-disk" {
  name           = "server1-linked.qcow2"
  pool           = var.libvirt_pool_name
  base_volume_id = "${var.libvirt_pool_path}/debian13-base.qcow2" 
  format         = "qcow2"
}

# Disco cloud-init con configuración del sistema
resource "libvirt_cloudinit_disk" "server1-cloudinit" {
  name           = "server1-cloudinit.iso"
  pool           = var.libvirt_pool_name
  user_data      = join("\n", ["#cloud-config", yamlencode(local.merged1)])
  network_config = file("${path.module}/cloud-init/server1/network-config.yaml")
}

# Dominio (VM)
resource "libvirt_domain" "server1" {
  name   = "server1"
  memory = 1024
  vcpu   = 2

 
 
   # Forzar que la red se cree antes de la VM
  depends_on = [
    libvirt_network.nat-dhcp,
    libvirt_network.muy-aislada
  ]
  
  network_interface {
    network_name   = "nat-dhcp"
    wait_for_lease = true
  }

  # Red 2: Red muy-aislada
  network_interface {
    network_name   = "muy-aislada"
  }

  disk {volume_id = libvirt_volume.server1-disk.id}
  cloudinit = libvirt_cloudinit_disk.server1-cloudinit.id
}

