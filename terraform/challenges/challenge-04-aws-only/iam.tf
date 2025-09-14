# IAM policy for snapshot access (CloudCopy attack vector)
resource "aws_iam_policy" "snapshot_access" {
  name        = "${var.project_name}-${var.challenge_name}-snapshot-access-${random_string.suffix.result}"
  description = "Policy allowing snapshot enumeration and sharing for CTF Challenge 04"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "DescribeSnapshots"
        Effect = "Allow"
        Action = [
          "ec2:DescribeSnapshots",
          "ec2:DescribeVolumes",
          "ec2:DescribeInstances"
        ]
        Resource = "*"
      },
      {
        Sid    = "ModifySnapshotAttributes"
        Effect = "Allow"
        Action = [
          "ec2:ModifySnapshotAttribute"
        ]
        Resource = "*"
        Condition = {
          StringEquals = {
            "ec2:ResourceTag/Challenge" = var.challenge_name
          }
        }
      }
    ]
  })

  tags = {
    Name        = "${var.project_name}-${var.challenge_name}-snapshot-policy-${random_string.suffix.result}"
    Description = "Snapshot access policy for CTF participants"
  }
}

# IAM user for CTF participants (carlos.cardenas)
resource "aws_iam_user" "carlos_cardenas" {
  name = "carlos.cardenas"
  path = "/ctf-users/"

  tags = {
    Name        = "carlos.cardenas"
    Challenge   = var.challenge_name
    Description = "CTF participant user for Challenge 04"
    Role        = "CTF-Participant"
  }
}

# Attach snapshot policy to carlos.cardenas
resource "aws_iam_user_policy_attachment" "carlos_snapshot_access" {
  user       = aws_iam_user.carlos_cardenas.name
  policy_arn = aws_iam_policy.snapshot_access.arn
}

# Create access key for carlos.cardenas
resource "aws_iam_access_key" "carlos_access_key" {
  user = aws_iam_user.carlos_cardenas.name

  # Store in Terraform state (for CTF purposes only)
  # In production, this should be handled more securely
}

# Additional IAM policy to prevent privilege escalation
resource "aws_iam_policy" "deny_dangerous_actions" {
  name        = "${var.project_name}-${var.challenge_name}-deny-dangerous-${random_string.suffix.result}"
  description = "Policy to prevent dangerous actions that could break the CTF environment"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "DenyDangerousEC2Actions"
        Effect = "Deny"
        Action = [
          "ec2:CreateSnapshot",
          "ec2:RunInstances",
          "ec2:CreateVolume",
          "ec2:TerminateInstances",
          "ec2:StopInstances",
          "ec2:StartInstances",
          "ec2:RebootInstances",
          "ec2:DeleteSnapshot",
          "ec2:CreateImage",
          "ec2:DeregisterImage"
        ]
        Resource = "*"
        Condition = {
          StringEquals = {
            "aws:RequestedRegion" = var.aws_region
          }
        }
      },
      {
        Sid    = "DenyIAMActions"
        Effect = "Deny"
        Action = [
          "iam:*"
        ]
        Resource = "*"
      },
      {
        Sid    = "DenySTSActions"
        Effect = "Deny"
        Action = [
          "sts:AssumeRole"
        ]
        Resource = "*"
      }
    ]
  })

  tags = {
    Name        = "${var.project_name}-${var.challenge_name}-deny-policy-${random_string.suffix.result}"
    Description = "Deny policy to prevent CTF environment damage"
  }
}

# Attach deny policy to carlos.cardenas
resource "aws_iam_user_policy_attachment" "carlos_deny_policy" {
  user       = aws_iam_user.carlos_cardenas.name
  policy_arn = aws_iam_policy.deny_dangerous_actions.arn
}
