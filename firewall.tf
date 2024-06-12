# Create Firewall rules for allow-ssh 
resource "google_compute_firewall" "ssh" {
  name = "allow-ssh-my-tf-vpc"
  allow {
    ports = ["22"]
    protocol = "tcp"
 }
 direction     = "INGRESS"
 network       = google_compute_network.vpc_network.id
 priority      = 1000
 source_ranges = ["0.0.0.0/0"]
 target_tags   = ["ssh"] 
}

# Create Firewall rules for allow-http-https 
resource "google_compute_firewall" "http-https" {
  name = "allow-http-https-my-tf-vpc"
  allow {
    ports = ["80","443"]
    protocol = "tcp"
 }
 direction     = "INGRESS"
 network       = google_compute_network.vpc_network.id
 priority      = 1000
 source_ranges = ["0.0.0.0/0"]
 target_tags   = ["http","https"] 
}
