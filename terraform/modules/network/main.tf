########################################
# modules/network/main.tf
########################################

resource "libvirt_network" "net" {
  for_each = var.networks

  name      = each.value.name
  mode      = each.value.mode
  bridge    = each.value.bridge
  domain    = lookup(each.value, "domain", null)
  addresses = lookup(each.value, "addresses", [])
  autostart = lookup(each.value, "autostart", true)

  dhcp {
    enabled = lookup(each.value, "dhcp", false)
  }

  dns {
    enabled = lookup(each.value, "dns", false)
  }
}
