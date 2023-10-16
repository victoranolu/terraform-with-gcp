# Add bucket to CDN backend

resource "google_compute_backend_bucket" "buck" {
  name        = "web-bucket"
  bucket_name = google_storage_bucket.webb.name
  description = " Conatains all the files for the website"
  enable_cdn  = true
}