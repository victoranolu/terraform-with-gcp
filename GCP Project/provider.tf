# Google Proider

provider "google" {
  project     = "web-hosting-402010"
  region      = "europe-west2"
  credentials = file("../web-hosting-402010-420b169dd131.json")
}