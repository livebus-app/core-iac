resource "aws_iam_role" "lambda" {
  name               = "lambda"
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

resource "aws_lambda_function" "label-analysis" {
  function_name = "label-analysis"
  role          = aws_iam_role.lambda.arn
  package_type  = "Image"
  image_uri     = "033809494047.dkr.ecr.us-east-1.amazonaws.com/label-analysis:latest"
  timeout       = 10
  memory_size   = "128"
  architectures = ["arm64"]
}
