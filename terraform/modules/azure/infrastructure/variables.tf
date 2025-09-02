variable "project_name" {
  description = "Name of the project"
  type        = string
  default     = "ctf-25"
}

variable "location" {
  description = "Azure location for resources"
  type        = string
  default     = "East US"
}

variable "index_html_path" {
  description = "Path to the index.html file"
  type        = string
}

variable "flag_txt_path" {
  description = "Path to the flag.txt file"
  type        = string
}

variable "tags" {
  description = "Additional tags for resources"
  type        = map(string)
  default     = {}
}
