variable "project" {
  description = "NY-Citi-Bike project ID"
  default     = "data-kestra1" # Your actual project ID
}

variable "region" {
  description = "Google Cloud region"
  default     = "us-west1" # Valid region
}

variable "location" {
  description = "Location for storage resources"
  default     = "us-west1" # For storage buckets, can also be specific regions
}

variable "bq_dataset_name" {
  description = "BigQuery dataset name"
  default     = "ny_citi_bike"
}

variable "gcs_bucket_name" {
  description = "Storage bucket name"
  default     = "echaligha_citi_bike_bucket" # Note: corrected typo from your original
}

variable "gcs_storage_class" {
  description = "Bucket Storage Class"
  default     = "STANDARD"
}

