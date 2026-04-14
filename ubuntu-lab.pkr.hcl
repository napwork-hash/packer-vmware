packer {
  required_plugins {
    vmware = {
      source  = "github.com/hashicorp/vmware"
      version = ">= 1.0.0"
    }
  }
}

variable "vm_count" {
  default = 4
}

variable "vm_name_prefix" {
  default = "Ubuntu Lab"
}

variable "start_index" {
  default = 10
}

locals {
  vm_names = [for i in range(var.vm_count) : "${var.vm_name_prefix} - ${var.start_index + i}"]
}

source "vmware-iso" "ubuntu_lab" {
  # ISO
  iso_url      = "D:/ISO Data/ubuntu-22.04.5-live-server-amd64.iso"
  iso_checksum = "sha256:9bc6028870aef3f74f4e16b900008179e78b130e6b0b9a140635434a46aa98b0"

  # VM Spec
  vm_name       = "ubuntu-lab-template"
  guest_os_type = "ubuntu-64"
  cpus          = 1
  memory        = 2048
  disk_size     = 20480
  disk_type_id  = 0

  # Network
  network              = "bridged"
  network_adapter_type = "vmxnet3"

  # Output
  output_directory = "D:/ISO Data/ubuntu-lab-template"

  # HTTP server
  http_directory = "http"
  http_port_min  = 8100
  http_port_max  = 8100

  # Boot command untuk Ubuntu 22.04 live server
  boot_wait = "3s"
  boot_command = [
    "<wait3>",
    "e<wait3>",
    "<down><down><down><end>",
    " autoinstall ds=nocloud-net\\;s=http://{{ .HTTPIP }}:{{ .HTTPPort }}/",
    "<F10><wait>"
  ]

  # SSH
  ssh_username           = "ubuntu"
  ssh_password           = "123465"
  ssh_timeout            = "60m"
  ssh_handshake_attempts = 300

  shutdown_command = "echo '123465' | sudo -S shutdown -P now"
}

build {
  name    = "ubuntu-labs"
  sources = ["source.vmware-iso.ubuntu_lab"]

  provisioner "shell" {
    inline = [
      "sudo apt-get update -y",
      "sudo apt-get install -y open-vm-tools",
      "echo 'VM ready'"
    ]
  }
}