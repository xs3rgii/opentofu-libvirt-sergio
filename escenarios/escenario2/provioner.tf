########################################
# Aprovisionamiento: copia de ficheros al backend
########################################

resource "null_resource" "copy_files_backend" {
  # Nos aseguramos de que la VM esté creada antes de copiar
  depends_on = [module.server["backend"]]

  # Conexión SSH al backend
  connection {
    type  = "ssh"
    user  = "debian"
    agent = true
    host  = module.server["backend"].vm_info.ips[0]
  }
  # Copia la carpeta al servidor remoto
  provisioner "file" {
    source      = "ficheros"
    destination = "/tmp"
  }
}
