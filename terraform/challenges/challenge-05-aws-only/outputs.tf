output "challenge_info" {
  description = "Challenge information and access details"
  value = {
    challenge_name   = "Challenge 05 - MediCloudX Reverse Engineering"
    bucket_name     = aws_s3_bucket.patient_data.bucket
    bucket_suffix   = local.resource_suffix
    iam_user        = aws_iam_user.exporter_user.name
    flag_location   = "admin/system_backup/flag.txt"
  }
}

output "binary_build_info" {
  description = "Information for building the challenge binary"
  value = {
    source_file     = "medicloudx_exporter.c"
    makefile        = "Makefile"
    binary_name     = "medicloudx_exporter"
    build_command   = "make"
  }
}

output "embedded_credentials" {
  description = "AWS credentials embedded in the binary"
  value = {
    access_key = aws_iam_access_key.exporter_keys.id
    secret_key = aws_iam_access_key.exporter_keys.secret
  }
  sensitive = true
}

output "s3_details" {
  description = "S3 bucket information for the challenge"
  value = {
    bucket_arn      = aws_s3_bucket.patient_data.arn
    bucket_region   = aws_s3_bucket.patient_data.region
    objects = {
      flag_file           = "admin/system_backup/flag.txt"
      patient_manifest    = "exports/patient_manifest.json"
      cardiovascular_data = "exports/cardiovascular_patients.json"
      lab_results        = "exports/lab_results.json"
    }
  }
}

output "challenge_summary" {
  description = "Challenge completion summary"
  value = <<-EOT
    
    =============================================================
    Challenge 05 - MediCloudX Data Exporter (Reverse Engineering)
    =============================================================
    
    Bucket Name: ${aws_s3_bucket.patient_data.bucket}
    Bucket Suffix: ${local.resource_suffix}
    
    Binary Information:
    - Source: medicloudx_exporter.c
    - Build: make
    - Target: medicloudx_exporter
    
    Usage:
    ./medicloudx_exporter --bucket ${local.resource_suffix}
    
    Flag Location: admin/system_backup/flag.txt
    
    =============================================================
  EOT
}

# Export bucket suffix to file for easy access
resource "local_file" "bucket_suffix" {
  content  = local.resource_suffix
  filename = "${path.module}/bucket_suffix.txt"
}

# Export the complete binary usage example
resource "local_file" "usage_example" {
  content = <<-EOT
#!/bin/bash
# MediCloudX Data Exporter - Usage Example
# 
# Build the binary:
make

# Run the exporter:
./medicloudx_exporter --bucket ${local.resource_suffix}

# Show version:
./medicloudx_exporter --version

# The binary contains embedded AWS credentials that can be extracted through:
# - Static analysis (strings, objdump, ghidra)
# - Dynamic analysis (gdb, strace)
# - Reverse engineering tools
EOT
  filename = "${path.module}/run_example.sh"
  file_permission = "0755"
}
