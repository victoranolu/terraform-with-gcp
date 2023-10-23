# Bucket to host website

resource "google_storage_bucket" "webb" {
  name     = var.project-name
  location = var.project-location
}

# Make object in the bucket accessible

resource "google_storage_object_access_control" "pub" {
  object = google_storage_bucket_object.index.name
  bucket = google_storage_bucket.webb.name
  role   = "READER"
  entity = "allUsers"
}

# Upload index.html website to storage bucket

resource "google_storage_bucket_object" "index" {
  name   = "index.html"
  source = "../html5up-dimension/index.html"
  bucket = google_storage_bucket.webb.name
}

# Creating a Public IP for the domain

resource "google_compute_global_address" "public-ip" {
  name = "lb-public-ip"
}



# Mapping the URL

resource "google_compute_url_map" "web-map" {
  name            = "web-map"
  default_service = google_compute_backend_bucket.buck.self_link

  host_rule {
    hosts        = ["*"]
    path_matcher = "allpaths"
  }

  path_matcher {
    name            = "allpaths"
    default_service = google_compute_backend_bucket.buck.self_link
  }
}

# Create the load balancer

resource "google_compute_target_http_proxy" "load-lb" {
  name    = "web-load-balancer"
  url_map = google_compute_url_map.web-map.self_link
}

# GCP forwarding rule 

resource "google_compute_global_forwarding_rule" "ruling" {
  name                  = "web-forwarding-rule"
  load_balancing_scheme = "EXTERNAL"
  ip_address            = google_compute_global_address.public-ip.address
  ip_protocol           = var.ip-protocol
  port_range            = var.port_range
  target                = google_compute_target_http_proxy.load-lb.self_link
}

# Creating a doamin zone

resource "google_dns_managed_zone" "dns_zone" {
  name        = "poormanalfredzone"
  dns_name    = var.dns_name
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

# Add bucket to CDN backend

resource "google_compute_backend_bucket" "buck" {
  name        = "web-bucket"
  bucket_name = google_storage_bucket.webb.name
  description = " Conatains all the files for the website"
  enable_cdn  = true
}