resource "aws_iam_role" "lambda_role" {
  name               = "lambda-role"
  assume_role_policy = <<EOF
  {
    "Version": "2012-10-17",
    "Statement": [
      {
        "Action": "sts:AssumeRole",
        "Principal": {
          "Service": "lambda.amazonaws.com"
        },
        "Effect": "Allow",
        "Sid": ""
      }
    ]
  }
  EOF
}

resource "aws_iam_role_policy" "lambda_policy" {
  name = "lambda-analysis-policy"
  role = aws_iam_role.lambda_role.id

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "s3:*",
        "ses:*",
        "dynamodb:PutItem",
        "rekognition:*",
        "rds:*",
        "logs:*"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}

resource "aws_lambda_function" "label-analysis" {
  function_name = "label-analysis"
  role          = aws_iam_role.lambda_role.arn
  package_type  = "Image"
  image_uri     = "798922568248.dkr.ecr.us-east-1.amazonaws.com/label-analysis:latest"
  timeout       = 10
  memory_size   = "128"
  architectures = ["x86_64"]
}

resource "aws_lambda_function" "label-digest" {
  function_name = "label-digest"
  role          = aws_iam_role.lambda_role.arn
  package_type  = "Image"
  image_uri     = "798922568248.dkr.ecr.us-east-1.amazonaws.com/label-digest:latest"
  timeout       = 10
  memory_size   = "128"
  architectures = ["x86_64"]
}

resource "aws_lambda_function" "put_rds" {
  function_name = "put-rds"
  role          = aws_iam_role.lambda_role.arn
  package_type  = "Image"
  image_uri     = "798922568248.dkr.ecr.us-east-1.amazonaws.com/put-rds:latest"
  timeout       = 10
  memory_size   = "128"
  architectures = ["x86_64"]
}


