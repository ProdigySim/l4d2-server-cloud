resource "openstack_dns_zone_v2" "cloud_psim" {
  name        = "cloud.prodigysim.com."
  email       = "admin@prodigysim.com"
  description = "Cloud Zone"
  ttl         = 3000
  type        = "PRIMARY"
}


resource "openstack_dns_recordset_v2" "serverptr" {
  zone_id     = openstack_dns_zone_v2.cloud_psim.id
  name        = "server.cloud.prodigysim.com."
  description = "Server pointer"
  ttl         = 60
  type        = "A"
  records     = [openstack_compute_instance_v2.basic.network[0].fixed_ip_v4]
}