########################################
# modules/network/outputs.tf
########################################

# Exporta los IDs de las redes creadas
output "ids" {
  description = "Mapa con los IDs de cada red creada"
  value = { for name, net in libvirt_network.net : name => net.id }
}

# Exporta los nombres de las redes
output "names" {
  description = "Mapa con los nombres de las redes"
  value = { for name, net in libvirt_network.net : name => net.name }
}
