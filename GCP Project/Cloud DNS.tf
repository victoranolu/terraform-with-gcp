# Creating a Public IP for the domain

resource "google_compute_global_address" "public-ip" {
  name = "lb-public-ip"
}

# Creating a doamin zone

resource "google_dns_managed_zone" "dns_zone" {
  name        = "poormanalfredzone"
  dns_name    = "poormanalfred.me."
  description = "DNS for this dev project"
}

# Add IP to DNS zone

resource "google_dns_record_set" "web-set" {
  name         = google_dns_managed_zone.dns_zone.dns_name
  managed_zone = google_dns_managed_zone.dns_zone.name
  type         = "A"
  ttl          = "300"
  rrdatas      = [google_compute_global_address.public-ip.address]
}
