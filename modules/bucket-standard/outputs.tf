output "nome" {
  description = "Nome del bucket creato dal modulo"
  value       = aws_s3_bucket.this.bucket
}

output "arn" {
  description = "ARN del bucket creato dal modulo"
  value       = aws_s3_bucket.this.arn
}
