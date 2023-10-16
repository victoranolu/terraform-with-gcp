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
  ip_protocol           = "TCP"
  port_range            = "80"
  target                = google_compute_target_http_proxy.load-lb.self_link
}