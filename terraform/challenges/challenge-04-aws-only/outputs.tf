# Outputs for CTF Challenge 04 - CloudCopy Attack

output "challenge_info" {
  description = "Challenge information and instructions"
  value = {
    challenge_name        = var.challenge_name
    challenge_description = "CloudCopy - Stealing NTDS hashes via EBS snapshots"
    domain_name          = var.domain_name
    attack_technique     = "EBS Snapshot NTDS Extraction"
  }
}

output "domain_controller_info" {
  description = "Domain Controller instance information"
  value = {
    instance_id   = aws_instance.domain_controller.id
    instance_name = aws_instance.domain_controller.tags.Name
    public_ip     = aws_instance.domain_controller.public_ip
    private_ip    = aws_instance.domain_controller.private_ip
    domain_name   = var.domain_name
  }
}

output "snapshot_info" {
  description = "EBS Snapshot information for the attack"
  value = {
    snapshot_id          = aws_ebs_snapshot.dc_snapshot.id
    snapshot_description = aws_ebs_snapshot.dc_snapshot.description
    volume_id           = data.aws_ebs_volume.dc_root_volume.id
    volume_size         = data.aws_ebs_volume.dc_root_volume.size
  }
}

output "iam_user_credentials" {
  description = "IAM user credentials for CTF participants"
  value = {
    username          = aws_iam_user.carlos_cardenas.name
    access_key_id     = aws_iam_access_key.carlos_access_key.id
    secret_access_key = aws_iam_access_key.carlos_access_key.secret
  }
  sensitive = true
}

output "attack_flow_summary" {
  description = "Summary of the attack flow for participants"
  value = {
    step_1 = "Use carlos.cardenas credentials to list EBS snapshots"
    step_2 = "Find the EkoCloudSecDC snapshot using ec2:DescribeSnapshots"
    step_3 = "Snapshot is already PUBLIC - accessible from any AWS account"
    step_4 = "In your personal account, copy the public snapshot directly"
    step_5 = "Create a volume from the copied snapshot in the same AZ as your attack instance"
    step_6 = "Launch an attack instance and attach the volume"
    step_7 = "Mount the volume and extract C:\\Windows\\NTDS\\ntds.dit and C:\\Windows\\System32\\config\\SYSTEM"
    step_8 = "Use secretsdump.py to extract hashes: secretsdump.py -system ./SYSTEM -ntds ./ntds.dit local"
    step_9 = "Find the NT hash for svc-flag user - this is your flag"
  }
}

output "target_credentials" {
  description = "Information about target credentials (for challenge validation)"
  value = {
    target_user     = "svc-flag"
    domain         = var.domain_name
    password_hint  = "Weak password following common patterns"
  }
  sensitive = true
}

output "networking_info" {
  description = "Network configuration information"
  value = {
    vpc_id              = aws_vpc.main.id
    public_subnet_id    = aws_subnet.public.id
    security_group_id   = aws_security_group.dc.id
    availability_zone   = aws_subnet.public.availability_zone
  }
}

output "web_content_url" {
  description = "URL to challenge web content"
  value       = "https://ctf-25-challenge-04-aws.s3.amazonaws.com/index.html"
}
