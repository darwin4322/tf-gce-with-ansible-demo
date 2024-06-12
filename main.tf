terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
      version = "~>5.0"
    }
  }
}

# gcp projectid_region_zone
provider "google" { 
    project = var.project-id
    region = var.region
    zone   = var.zone
  
}

# Create SSH-KEY
resource "tls_private_key" "key" {
  algorithm = "ED25519"
}

resource "local_file" "public_key" {
  filename        = "server_public_openssh"
  content         = trimspace(tls_private_key.key.public_key_openssh)
  file_permission = "0400"
}

resource "local_sensitive_file" "private_key" {
  filename = "server_private_openssh"
  content         = tls_private_key.key.private_key_openssh
  file_permission = "0400"
}

 
# Create a Static IP
resource "google_compute_address" "static" {
  name = "ipv4-address"
  address_type = "EXTERNAL"
  network_tier = "PREMIUM"
}


# Create a single Compute Engine instance
resource "google_compute_instance" "tf_instance" {
  name         = var.vmname
  machine_type = var.machine_type
  zone         = var.zone
  tags         = var.tags

 boot_disk {
    initialize_params {
      image = var.image
    }
  }

 network_interface {
    subnetwork = google_compute_subnetwork.default.id
    access_config {
      nat_ip = google_compute_address.static.address
    }
 }
 metadata = {
     ssh-keys = "${var.ssh_user}:${local_file.public_key.content}"
     block-project-ssh-keys = true
  }

# remote install ansible
 provisioner "remote-exec" {
    inline = [
      "sudo apt update -y",
      "sudo apt install -y software-properties-common",
      "sudo apt-add-repository --yes --update ppa:ansible/ansible",
      "sudo apt install -y ansible"
    ]

    connection {
      type        = "ssh"
      user        = "${var.ssh_user}"
      host        = google_compute_address.static.address
      private_key = tls_private_key.key.private_key_openssh
    }
  }
  
 provisioner "local-exec" {
     command = "ansible-playbook -u ${var.ssh_user} --key-file server_private_openssh -i '${google_compute_address.static.address},', app.yaml" 
  } 

}

 output "ansible_command" {
     value = "ansible-playbook -u ${var.ssh_user} --key-file server_private_openssh -i '${google_compute_address.static.address},', app.yaml"
 }

