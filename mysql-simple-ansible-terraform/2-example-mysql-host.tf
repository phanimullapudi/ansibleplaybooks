locals {
  project_id       = "pulumi-367411"
  network          = "default"
  image            = "ubuntu-2004-focal-v20221018"
  ssh_user         = "ansible"
  private_key_path = "~/.ssh/ansible_key"

  db_servers = {
    mysql-000-staging = {
      mysql_role   = "master"
      machine_type = "e2-micro"
      zone         = "us-central1-a"
    }

    mysql-001-staging = {
      mysql_role   = "slave"
      machine_type = "e2-micro"
      zone         = "us-central1-a"
    }
  }
}

provider "google" {
  project = local.project_id
  region  = "us-central1"
}

resource "google_service_account" "mysql" {
  account_id = "mysql-demo"
}

resource "google_compute_firewall" "db" {
  name    = "db-access"
  network = local.network

  allow {
    protocol = "tcp"
    ports    = ["3306"]
  }

  source_ranges           = ["0.0.0.0/0"]
  target_service_accounts = [google_service_account.mysql.email]
}
resource "google_compute_instance" "mysql" {
  for_each = local.db_servers

  name         = each.key
  machine_type = each.value.machine_type
  zone         = each.value.zone

  boot_disk {
    initialize_params {
      image = local.image
    }
  }

  network_interface {
    network = local.network
    access_config {}
  }

  service_account {
    email  = google_service_account.mysql.email
    scopes = ["cloud-platform"]
  }

  provisioner "remote-exec" {
    inline = [
      "echo 'Wait until SSH is ready...'"
    ]

    connection {
      type        = "ssh"
      user        = local.ssh_user
      private_key = file(local.private_key_path)
      host        = self.network_interface.0.access_config.0.nat_ip
    }
  }

  provisioner "local-exec" {
    command = "ansible-playbook  -i ${self.network_interface.0.access_config.0.nat_ip}, --private-key ${local.private_key_path} mysql.yaml"
  }
}
output "mysql_ips" {
  value = {
    for k, v in google_compute_instance.mysql : k => "${v.network_interface.0.access_config.0.nat_ip}"
  }
}