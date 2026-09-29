import {
  to = aws_s3_bucket.archivio
  id = "prenotalab-${var.matricola}-archivio"
}

resource "aws_s3_bucket" "archivio" {
  bucket        = "prenotalab-${var.matricola}-archivio"
  force_destroy = true
  tags          = local.common_tags
}