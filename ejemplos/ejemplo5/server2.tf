# Clon ligero (backing store)
# El disco resultante apunta al volumen base y solo guarda cambios diferenciales
resource "libvirt_volume" "server2-disk" {
  name           = "server2-linked.qcow2"
  pool           = var.libvirt_pool_name
  base_volume_id = "${var.libvirt_pool_path}/ubuntu2404-base.qcow2" 
  format         = "qcow2"
}

# Disco cloud-init con configuración del sistema
resource "libvirt_cloudinit_disk" "server2-cloudinit" {
  name           = "server2-cloudinit.iso"
  pool           = var.libvirt_pool_name
  user_data      = file("${path.module}/cloud-init/server2/user-data.yaml")
  network_config = file("${path.module}/cloud-init/server2/network-config.yaml")
}

# Dominio (VM)
resource "libvirt_domain" "server2" {
  name   = "server2"
  memory = 1024
  vcpu   = 2

 
 
  # Forzar que la red se cree antes de la VM
  depends_on = [libvirt_network.muy-aislada]
  
  network_interface {
    network_name   = "muy-aislada"
  }

  disk {volume_id = libvirt_volume.server2-disk.id}
  cloudinit = libvirt_cloudinit_disk.server2-cloudinit.id

}

