# Bucket to host website

resource "google_storage_bucket" "webb" {
  name     = "icanbewhatiwanttobe"
  location = "EU"
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

