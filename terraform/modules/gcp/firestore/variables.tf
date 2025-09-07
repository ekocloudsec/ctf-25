variable "project_name" {
  description = "Name of the project"
  type        = string
  default     = "ctf-25"
}

variable "region" {
  description = "GCP region for resources"
  type        = string
  default     = "us-east1"
}

variable "database_name" {
  description = "Name of the Firestore database"
  type        = string
  default     = "ctf-audit"
}

variable "collection_name" {
  description = "Name of the Firestore collection"
  type        = string
}

variable "log_entries" {
  description = "Map of log entries to create in the collection"
  type        = map(any)
}

variable "labels" {
  description = "Additional labels for resources"
  type        = map(string)
  default     = {}
}
