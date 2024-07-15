
resource "aws_lambda_function" "my_lambda" {
  function_name = "my_lambda_function"
  role          = aws_iam_role.lambda_role.arn
  handler       = "index.handler"
  runtime       = "python3.8" # Change this to your desired runtime

  # Upload your zip file containing the function code
  filename         = "scripts/lambda.zip"
  source_code_hash = filebase64sha256("scripts/lambda.zip")

  # Remove ephemeral storage block

  # Configure memory
  memory_size = 512 # Change this to your desired memory size (in MB)
  timeout     = 3
  # Add ReservedConcurrency settings
  reserved_concurrent_executions = 5 # Example value, adjust as needed

  environment {
    variables = {
      # Add your environment variables here
      EXAMPLE_VAR = "example_value"
    }
  }

  lifecycle {
    ignore_changes = [
      memory_size,
      reserved_concurrent_executions,
      timeout
    ]
  }
}

resource "aws_lambda_provisioned_concurrency_config" "example" {
  function_name                     = aws_lambda_function.my_lambda.function_name
  provisioned_concurrent_executions = 10
  qualifier                         = aws_lambda_function.my_lambda.version
  lifecycle {
    ignore_changes = [
      provisioned_concurrent_executions
    ]
  }
}


output "lambda_function_name" {
  value = aws_lambda_function.my_lambda.function_name
}

output "lambda_function_arn" {
  value = aws_lambda_function.my_lambda.arn
}
