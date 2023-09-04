// create output terraform

output "label_analysis_lambda_arn" {
  value = aws_lambda_function.label-analysis.arn
}

output "put_rds_lambda_arn" {
  value = aws_lambda_function.put_rds.arn
}

output "label_digest_lambda_arn" {
  value = aws_lambda_function.label-digest.arn
}