# Create a VPC network
resource "google_compute_network" "vpc_network" {
  name                    = var.network
  auto_create_subnetworks = false
  mtu                     = 1460
}

# Create a VPC subnetwork
resource "google_compute_subnetwork" "default" {
  name          = var.subnetwork
  ip_cidr_range = "192.168.1.0/24"
  region        = var.region
  network       = google_compute_network.vpc_network.id
}
