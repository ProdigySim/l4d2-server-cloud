terraform {
required_version = ">= 0.14.0"
  required_providers {
    openstack = {
      source  = "terraform-provider-openstack/openstack"
      version = "~> 1.53.0"
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