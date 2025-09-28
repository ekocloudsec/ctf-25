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

variable "index_html_path" {
  description = "Path to the index.html file"
  type        = string
}

variable "flag_txt_path" {
  description = "Path to the flag.txt file"
  type        = string
}

variable "labels" {
  description = "Additional labels for resources"
  type        = map(string)
  default     = {}
}

variable "discovery_key_path" {
  description = "Path to the medicloudx-discovery-key.json.b64 file"
  type        = string
  default     = ""
}
