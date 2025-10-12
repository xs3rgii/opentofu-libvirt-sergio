output "vms" {
  description = "Información de todas las máquinas virtuales creadas"
  value = {
    for name, mod in {
      server1 = module.server1
      server2 = module.server2
    } :
    name => mod.vm_info
  }
}