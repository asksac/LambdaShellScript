# define terraform module output values here 

output "lambda_arn" {
  description             = "Lambda ARN"
  value                   = aws_lambda_function.lambda_function.arn
}

/*
output "endpoint_dns" {
  description             = "List of Private DNS entries associated with the Lambda VPC endpoint"
  value                   = aws_vpc_endpoint.lambda_endpoint.dns_entry 
}
*/