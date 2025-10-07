variable "aws_region" {
  description = "AWS region for the challenge resources"
  type        = string
  default     = "us-east-1"
}

variable "aws_profile" {
  description = "AWS profile to use for authentication"
  type        = string
  default     = "default"
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "dev"
}

variable "flag_content" {
  description = "CTF flag content"
  type        = string
  default     = "CTF{m3d1cl0udx_r3v3rs3_3ng1n33r1ng_4ws_cr3d3nt14ls}"
}


variable "patient_records_count" {
  description = "Number of fake patient records to generate"
  type        = number
  default     = 50
}
