variable "project-id" {
  type = string
  description = "The project ID (required)"
  default = "dgctestingforusd"
}

variable "region" {
  type = string
  description = "The region to the VM"
  default = "asia-east1"
}

variable "zone" {
  type = string
  description = "The zones to the VM"
  default = "asia-east1-b"
}

variable "vmname" {
  type = string
  default = "tf-instance"
}

variable "machine_type" {
  type = string
  default = "e2-medium"
}

variable "image" {
  type = string
  default = "debian-cloud/debian-11"
}

variable "network" {
  type = string
  description = "VPC Name"
  default = "my-tf-vpc"
}

variable "subnetwork" {
  type = string
  description = "Subnet Name"
  default = "my-tf-subnet"
}

variable "tags" {
  type    = list(string)
  description = "Network tags"
  default = ["ssh","http","https"]
}

variable "ssh_user" {
  type        = string
  description = "SSH user for compute instance"
  default     = "devuser"
  sensitive   = false
}

variable "host_check" {
  type        = string
  description = "Dont add private key to known_hosts"
  default     = "-o StrictHostKeyChecking=no"
  sensitive   = false
}

variable "ignore_known_hosts" {
  type        = string
  description = "Ignore (many) keys stored in the ssh-agent; use explicitly declared keys"
  default     = "-o IdentitiesOnly=yes"
  sensitive   = false
}
