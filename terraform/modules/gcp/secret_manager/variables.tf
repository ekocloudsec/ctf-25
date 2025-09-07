variable "project_name" {
  description = "Name of the project"
  type        = string
  default     = "ctf-25"
}

variable "secret_name" {
  description = "Name of the Secret Manager secret"
  type        = string
}

variable "secret_data" {
  description = "Data to be stored in the secret"
  type        = string
  sensitive   = true
}

# KMS key not needed with auto replication

variable "labels" {
  description = "Additional labels for resources"
  type        = map(string)
  default     = {}
}

variable "secret_access_members" {
  description = "List of members who can access the secret (e.g., 'user:user@example.com')"
  type        = list(string)
  default     = []
}
