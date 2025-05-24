terraform {
  required_providers {
    openstack = {
      source  = "terraform-provider-openstack/openstack"
      version = "~> 3.0.0"
    }
  }
}

# Configure the OpenStack Provider
provider "openstack" {
}


resource "openstack_compute_keypair_v2" "test-keypair" {
  name       = "psim_alpc"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDGHhx+SvinGWrZZrtjB6MjdnhhO0+hCdRR1b1NuajOQ+LUKOJiVXYaAzLEKsL8YO8UGNANuscz4PTs4TPOKk5tQFT7AHN4x/7n/bqISxQ7Lj8BkekRTxtq+kil0e19uobB8xldQiHYauxuB2/tRN/JRSUMIN2c4ARX1xJ5fBD9xYaUrEzXy27EKpUGV0DGPRGIInpdMLinuJZvLpyjLYb1MkmzOYqpQVZdvDvs7B6wdIg/wPsz0aWqpcJXXEznQKME7IomZNEsB+ERnFwj6XOteJGoHUQsfItjXU9C1z+AZC5gMdpsOcPD4pGtErp01ECAicjCvI/o6wOJ90drJ9QP"
}

# Honestly just find any network...
data "openstack_networking_network_v2" "network" {
  name = "public"
}

data "openstack_compute_flavor_v2" "m2new" {
  name = "M2-new"
}

resource "openstack_networking_secgroup_v2" "ssh-incoming" {
  name        = "ssh-incoming"
  description = "Allow SSH incoming from just my IP"
}
resource "openstack_networking_secgroup_rule_v2" "ssh-incoming-rule" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 22
  port_range_max    = 22
  remote_ip_prefix  = "${var.ssh_allowed_ip}/32"
  security_group_id = openstack_networking_secgroup_v2.ssh-incoming.id
}

resource "openstack_networking_secgroup_v2" "l4d2-incoming" {
  name        = "l4d2-incoming"
  description = "Allow L4D2 incoming from any ip"
}
resource "openstack_networking_secgroup_rule_v2" "l4d2-incoming-rule" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "udp"
  port_range_min    = 27015
  port_range_max    = 27015
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = openstack_networking_secgroup_v2.l4d2-incoming.id
}

resource "openstack_compute_instance_v2" "basic" {
  name       = "basic"
  image_name = "ubuntu-24.04-x86_64"
  flavor_id  = data.openstack_compute_flavor_v2.m2new.id
  key_pair   = openstack_compute_keypair_v2.test-keypair.id
  security_groups = [
    "default",
    openstack_networking_secgroup_v2.ssh-incoming.name,
    openstack_networking_secgroup_v2.l4d2-incoming.name
  ]
  user_data = file("cloud_init_l4d2.yml")

  metadata = {
    this = "that"
  }

  network {
    name = data.openstack_networking_network_v2.network.name
  }
}