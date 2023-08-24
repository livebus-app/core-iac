resource "aws_sns_topic" "live-digest" {
  name = "live-digest"
}

resource "aws_sns_topic_subscription" "live-digest" {
  topic_arn = aws_sns_topic.live-digest.arn
  protocol  = "lambda"
  endpoint  = var.sns-lambda-arn
}

resource "aws_lambda_permission" "with_sns" {
    statement_id = "AllowExecutionFromSNS"
    action = "lambda:InvokeFunction"
    function_name = "${var.sns-lambda-name}"
    principal = "sns.amazonaws.com"
    source_arn = "${aws_sns_topic.live-digest.arn}"
}

// eventbridge pipeline
