# Lambda function for post-confirmation trigger
resource "aws_lambda_function" "post_confirmation" {
  filename         = "post_confirmation.zip"
  function_name    = "${var.project_name}-post-confirmation-${random_string.suffix.result}"
  role            = aws_iam_role.lambda_role.arn
  handler         = "index.handler"
  source_code_hash = data.archive_file.lambda_zip.output_base64sha256
  runtime         = "python3.9"
  timeout         = 30

  # Eliminar environment variables para romper la dependencia circular
  # La función Lambda recibirá el userPoolId en el evento

  tags = {
    Name = "${var.project_name}-post-confirmation"
  }
}

# Lambda deployment package
data "archive_file" "lambda_zip" {
  type        = "zip"
  output_path = "post_confirmation.zip"
  source {
    content = <<EOF
import boto3
import json
import os

def handler(event, context):
    client = boto3.client('cognito-idp')
    
    # Set default role to 'reader' for new users
    try:
        # El userPoolId viene en el evento mismo
        user_pool_id = event['userPoolId']
        username = event['userName']
        
        client.admin_update_user_attributes(
            UserPoolId=user_pool_id,
            Username=username,
            UserAttributes=[
                {
                    'Name': 'custom:role',
                    'Value': 'reader'
                }
            ]
        )
    except Exception as e:
        print(f"Error updating user attributes: {e}")
        print(f"Event data: {json.dumps(event)}")
    
    return event
EOF
    filename = "index.py"
  }
}

# Lambda permission for Cognito
resource "aws_lambda_permission" "cognito_invoke" {
  statement_id  = "AllowExecutionFromCognito"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.post_confirmation.function_name
  principal     = "cognito-idp.amazonaws.com"
  source_arn    = aws_cognito_user_pool.main.arn
}
