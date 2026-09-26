# Modulo aziendale "bucket-standard": gia' pronto, NON va modificato.
# Impone lo standard su ogni bucket: nome con schema fisso, cifratura,
# niente accessi pubblici, versioning (sempre acceso in prod), tag di costo.

locals {
  nome = "prenotalab-${var.matricola}-${var.ruolo}-${var.env}"

  tags = {
    Name       = local.nome
    Project    = "PrenotaLab"
    Env        = var.env
    Owner      = var.matricola
    CostCenter = var.cost_center
    ManagedBy  = "Terraform"
  }
}

resource "aws_s3_bucket" "this" {
  bucket = local.nome
  tags   = local.tags
}

resource "aws_s3_bucket_versioning" "this" {
  bucket = aws_s3_bucket.this.id

  versioning_configuration {
    status = (var.versioning || var.env == "prod") ? "Enabled" : "Suspended"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "this" {
  bucket = aws_s3_bucket.this.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_public_access_block" "this" {
  bucket = aws_s3_bucket.this.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
