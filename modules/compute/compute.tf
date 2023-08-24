resource "aws_iam_role" "lambda" {
  name = "lambda"
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

resource "aws_iam_role_policy" "revoke_keys_role_policy" {
  name = "sapato"
  role = aws_iam_role.lambda.id

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
        "rds:*"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}

resource "aws_ecr_repository" "live-digest" {
  name                 = "live-digest"
  image_tag_mutability = "MUTABLE"
  image_scanning_configuration {
    scan_on_push = true
  }
}

resource "aws_lambda_function" "live-digest" {
  function_name    = "live-digest"
  role             = aws_iam_role.lambda.arn
  image_uri     = "033809494047.dkr.ecr.us-east-1.amazonaws.com/live-digest:latest"
  package_type  = "Image"
  timeout          = 10
  memory_size      = "128"
  architectures = ["arm64"]
}
