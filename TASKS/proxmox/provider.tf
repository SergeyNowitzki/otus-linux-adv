variable "pm_api_url" {
  type = string
}

variable "proxmox_api_token_id" {
  type = string
  sensitive= true
}

variable "proxmox_password" {
  type = string
  sensitive= true
}

variable "proxmox_api_token_secret" {
  type = string
  sensitive = true
}

variable "proxmox_node" {
  type = string
}

variable "ssh_key" {
  type = string
}

variable "cloudinit_template_name" {
  type = string
}


terraform {
  
  required_version = ">= 0.13.0"

  required_providers {
    proxmox = {
      source = "Telmate/proxmox"
      version = "2.9.14"
    }
  }
}

provider "proxmox" {
  pm_api_url = var.pm_api_url
  pm_api_token_id = var.proxmox_api_token_id
  pm_api_token_secret = var.proxmox_api_token_secret
  pm_tls_insecure = true
  pm_password = var.proxmox_password
  pm_log_enable = true
  pm_log_file   = "terraform-plugin-proxmox.log"
  pm_debug      = true
  pm_log_levels = {
    _default    = "debug"
    _capturelog = ""
  }
}