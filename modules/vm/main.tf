resource "google_compute_instance" "vm" {
  name         = "private-web-vm"
  machine_type = "e2-micro"
  zone         = "${var.region}-a"

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-12"
    }
  }

  network_interface {
    subnetwork = var.subnet_id
    # NO external IP
  }

  metadata_startup_script = <<-EOF
    #!/bin/bash
    apt update -y
    apt install -y apache2
    echo "Hello from Private VM" > /var/www/html/index.html
    systemctl restart apache2
  EOF

  tags = ["web"]
}

resource "google_compute_instance_group" "ig" {
  name      = "web-ig"
  zone      = "${var.region}-a"
  instances = [google_compute_instance.vm.id]

  named_port {
    name = "http"
    port = 80
  }
}
