locals {
  lab_role_arn = "arn:aws:iam::117522125273:role/LabRole"
}

data "archive_file" "lambda" {
  type        = "zip"
  source_dir  = "${path.module}/function"
  output_path = "function.zip"

  depends_on = [ null_resource.main ]
}

resource "null_resource" "main" {
  triggers = {
    updated_at = timestamp()
  }

  provisioner "local-exec" {
    command = <<EOF
    rm -rf node_modules
    yarn
    EOF

    working_dir = "${path.module}/function"
  }
}

resource "aws_lambda_function" "object-digest-lambda" {
  filename         = "${data.archive_file.lambda.output_path}"
  function_name    = "object-digest-lambda"
  role             = "${local.lab_role_arn}"
  handler          = "index.handler"
  source_code_hash = "${base64sha256(filebase64("${data.archive_file.lambda.output_path}"))}"
  runtime          = "nodejs18.x"
  timeout          = "60"
  memory_size      = "128"
}