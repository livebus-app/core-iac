data "aws_iam_policy_document" "pipe_assume_policy_document" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["pipes.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "pipe_iam_policy_document" {
  statement {
    sid    = "AllowPipeAccess"
    effect = "Allow"
    actions = [
      "kinesis:DescribeStream",
      "kinesis:GetShardIterator",
      "kinesis:GetRecords",
      "kinesis:ListShards",
      "lambda:InvokeFunction"
    ]
    resources = [
      var.target_resource_arn,
      var.enrichment_lambda_arn,
      "arn:aws:lambda:us-east-1:033809494047:function:enrichment",
      var.lbl_dynamodb_insertion_stream_arn
    ]
  }
}

resource "aws_iam_role" "label_digestion_pipe_role" {
  name               = "label-digestion-pipe-role"
  assume_role_policy = data.aws_iam_policy_document.pipe_assume_policy_document.json
}

resource "aws_iam_role_policy" "label_digestion_pipe_role_policy" {
  name   = "label-digestion-pipe-role-policy"
  role   = aws_iam_role.label_digestion_pipe_role.name
  policy = data.aws_iam_policy_document.pipe_iam_policy_document.json
}

resource "awscc_pipes_pipe" "label_digestion_pipeline" {
  name     = "label-digestion-pipeline"
  role_arn = aws_iam_role.label_digestion_pipe_role.arn

  source = var.lbl_dynamodb_insertion_stream_arn
  source_parameters = {
    kinesis_stream_parameters = {
      starting_position = "LATEST"
    }

    filter_criteria = { 
      filters = [{ pattern = "{ \"data\": { \"eventName\": [\"INSERT\"] }}" }]
    }
  }

  enrichment = var.enrichment_lambda_arn
  target = var.target_resource_arn
}






























/* 
data "aws_iam_policy_document" "pipe_assume_policy_document" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["pipes.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "pipe_iam_policy_document" {
  statement {
    sid    = "AllowPipeToAccessSQS"
    effect = "Allow"
    actions = [
      "kinesis:DescribeStream",
      "kinesis:GetShardIterator",
      "kinesis:GetRecords",
      "kinesis:ListShards",
      "lambda:InvokeFunction"
    ]
    resources = [
      aws_kinesis_stream.lbl-dynamodb-insertion-stream.arn,
      "arn:aws:lambda:us-east-1:033809494047:function:teste",
      "arn:aws:lambda:us-east-1:033809494047:function:enrichment"
    ]
  }
}

resource "aws_iam_role" "pipe_iam_role" {
  name               = "pipe-sqs-rolee"
  assume_role_policy = data.aws_iam_policy_document.pipe_assume_policy_document.json
}

resource "aws_iam_role_policy" "pipe_iam_role_policy" {
  name   = "pipe-sqs-rolee-policy"
  role   = aws_iam_role.pipe_iam_role.id
  policy = data.aws_iam_policy_document.pipe_iam_policy_document.json
}

resource "awscc_pipes_pipe" "name" {
  name     = "pipe-name"
  role_arn = aws_iam_role.pipe_iam_role.arn

  source = aws_kinesis_stream.lbl-dynamodb-insertion-stream.arn
  source_parameters = {
    kinesis_stream_parameters = {
      starting_position = "LATEST"
    }

    filter_criteria = { 
      filters = [{ pattern = "{ \"data\": { \"eventName\": [\"INSERT\"] }}" }]
    }
  }

  enrichment = "arn:aws:lambda:us-east-1:033809494047:function:enrichment"

  target = "arn:aws:lambda:us-east-1:033809494047:function:teste"
}

resource "aws_iam_role" "lambda" {
  name               = "teste"
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

resource "aws_lambda_function" "label-digest" {
  function_name = "label-digest"
  role          = aws_iam_role.lambda.arn
  package_type  = "Image"
  image_uri     = "033809494047.dkr.ecr.us-east-1.amazonaws.com/label-digest:latest"
  timeout       = 10
  memory_size   = "128"
  architectures = ["x86_64"]
} */
