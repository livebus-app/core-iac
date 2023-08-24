// create output terraform

output "live-digest-lambda-arn" {
  value = aws_lambda_function.live-digest.arn
}

output "live-digest-lambda-name" {
  value = aws_lambda_function.live-digest.function_name
}