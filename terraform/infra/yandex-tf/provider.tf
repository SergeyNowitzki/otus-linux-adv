locals {
  cloud_id           = "YOUR_CLOUD_ID"
  folder_id          = "YOUR_FOLDER_ID" #service-folder
  zone               = "ru-central1-a"
}

terraform {
  required_version = ">= 0.13"

  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
  backend "s3" {
    endpoint = "storage.yandexcloud.net"
    bucket   = "otus-tf-bucket"
    region   = "ru-central1"
    key      = "environments/otus/yandex/terraform.tfstate"
    access_key = "YOUR_ACCESS_KEY_TO_THE_BUCKET"
    secret_key = "YOUR_PRIVATE_KEY_TO_THE_BUCKET"

    skip_region_validation      = true
    skip_credentials_validation = true
  }
}


provider "yandex" {
  cloud_id  = local.cloud_id
  folder_id = local.folder_id
  zone      = local.zone
}