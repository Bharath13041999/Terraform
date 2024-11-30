variable "resource_group_name" {
  description = "The name of the resource group"
  type        = string
}
 
variable "location" {
  description = "The location of the resources"
  type        = string
  default     = "East US"
}
 
variable "vm_name" {
  description = "The name of the Virtual Machine"
  type        = string
}
 
variable "vm_size" {
  description = "The size of the Virtual Machine"
  type        = string
  default     = "Standard_B2s"
}
 
variable "admin_username" {
  description = "The admin username for the VM"
  type        = string
}
 
variable "admin_password" {
  description = "The admin password for the VM"
  type        = string
}
 
variable "image_reference" {
  description = "Image reference for the VM"
  type        = object({
    publisher = string
    offer     = string
    sku       = string
    version   = string
  })
  default = {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "20.04-LTS"
    version   = "latest"
  }
}