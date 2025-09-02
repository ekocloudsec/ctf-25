variable "aws_region" {
  description = "AWS region for resources"
  type        = string
  default     = "us-east-1"
}

variable "azure_location" {
  description = "Azure location for resources"
  type        = string
  default     = "East US"
}

variable "gcp_project_id" {
  description = "GCP project ID"
  type        = string
}

variable "gcp_region" {
  description = "GCP region for resources"
  type        = string
  default     = "us-east1"
}


variable "project_name" {
  description = "Project name"
  type        = string
  default     = "ctf-25"
}
