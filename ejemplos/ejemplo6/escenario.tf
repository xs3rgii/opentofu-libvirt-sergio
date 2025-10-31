##############################################
# escenario.tf — Definición del escenario
##############################################

locals {

  ##############################################
  # Redes a crear
  ##############################################

  networks = {
    red-nat-dhcp = {
      name      = "red-nat-dhcp"
      mode      = "nat"
      domain    = "example.com"
      addresses = ["192.168.100.0/24"]
      bridge    = "virbr30"
      dhcp      = true
      dns       = true
      autostart = true
    }
  
    red-nat = {
      name      = "red-nat"
      mode      = "nat"
      domain    = "example.com"
      addresses = ["192.168.120.0/24"]
      bridge    = "virbr31"
      dhcp      = true
      dns       = true
      autostart = true
    }

    red-muy-aislada = {
      name      = "red-muy-aislada"
      mode      = "none" # sin conectividad
      bridge    = "virbr32"
      autostart = true
    }
  }

  ##############################################
  # Máquinas virtuales a crear
  ##############################################

servers = {
  server1 = {
    name       = "server1"
    memory     = 1024
    vcpu       = 2
    base_image = "debian13-base.qcow2"

    networks = [
      { network_name = "red-nat-dhcp", wait_for_lease = true },
      { network_name = "red-muy-aislada" }
    ]

    disks = [
      { name = "data", size = 5 * 1024 * 1024 * 1024 }
    ]

    user_data      = "${path.module}/cloud-init/server1/user-data.yaml"
    network_config = "${path.module}/cloud-init/server1/network-config.yaml"
  }

  server2 = {
    name       = "server2"
    memory     = 1024
    vcpu       = 2
    base_image = "ubuntu2404-base.qcow2"

    networks = [
      { network_name = "red-muy-aislada" }
    ]

    user_data      = "${path.module}/cloud-init/server2/user-data.yaml"
    network_config = "${path.module}/cloud-init/server2/network-config.yaml"
  }

  server3 = {
    name       = "server3"
    memory     = 1024
    vcpu       = 2
    base_image = "ubuntu2404-base.qcow2"

    networks = [
      { network_name = "red-nat", wait_for_lease = true },
      { network_name = "red-muy-aislada" }
    ]

    disks = [
      { name = "data", size = 5 * 1024 * 1024 * 1024 }
    ]

    user_data      = "${path.module}/cloud-init/server3/user-data.yaml"
    network_config = "${path.module}/cloud-init/server3/network-config.yaml"
  }
}
}
