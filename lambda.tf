resource "aws_iam_role" "lambda_role" {
  name = "lambda-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Principal = {
          Service = "lambda.amazonaws.com",
        },
        Effect = "Allow",
        Sid    = "",
      },
    ],
  })
}

resource "aws_iam_policy" "lambda_policy" {
  name = "lambda-policy"
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents",
        ],
        Effect   = "Allow",
        Resource = "arn:aws:logs:*:*:*",
      },
    ],
  })
}

resource "aws_iam_role_policy_attachment" "lambda_policy_attachment" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = aws_iam_policy.lambda_policy.arn
}

resource "aws_lambda_function" "my_lambda" {
  function_name = "my_lambda_function"
  role          = aws_iam_role.lambda_role.arn
  handler       = "index.handler"
  runtime       = "python3.8" # Change this to your desired runtime

  # Upload your zip file containing the function code
  filename         = "path/to/your/lambda.zip"
  source_code_hash = filebase64sha256("path/to/your/lambda.zip")

  # Remove ephemeral storage block

  # Configure memory
  memory_size = 512 # Change this to your desired memory size (in MB)

  # Add ProvisionedConcurrency and ReservedConcurrency settings
  provisioned_concurrent_executions = 10 # Example value, adjust as needed
  reserved_concurrent_executions    = 5  # Example value, adjust as needed

  environment {
    variables = {
      # Add your environment variables here
      EXAMPLE_VAR = "example_value"
    }
  }

  lifecycle {
    ignore_changes = [
      memory_size,
      provisioned_concurrent_executions,
      reserved_concurrent_executions,
    ]
  }
}


output "lambda_function_name" {
  value = aws_lambda_function.my_lambda.function_name
}

output "lambda_function_arn" {
  value = aws_lambda_function.my_lambda.arn
}
