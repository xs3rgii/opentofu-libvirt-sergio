variable "networks" {
  description = "Listado de redes a crear"
  type = map(object({
    name       = string
    mode       = string
    bridge     = string
    domain     = optional(string)
    addresses  = optional(list(string))
    dhcp       = optional(bool, false)
    dns        = optional(bool, false)
    autostart  = optional(bool, true)
  }))
}

