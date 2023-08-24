// create output terraform

output "label-analysis-lambda-arn" {
  value = aws_lambda_function.label-analysis.arn
}

output "label-analysis-lambda-name" {
  value = aws_lambda_function.label-analysis.function_name
}