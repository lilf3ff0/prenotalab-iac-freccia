##############################################################
# VERIFICA DI RECUPERO IaC - PROVA PRATICA
# Commessa "PrenotaLab": il sistema con cui l'ITS prenota le
# aule laboratorio passa sotto Terraform. Completa i TODO e
# segui le fasi indicate sul documento di laboratorio.
##############################################################

terraform {
  required_version = ">= 1.6"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

# --- gia' pronto: non serve modificarlo -----------------------
data "aws_ami" "al2023" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-2023.*-x86_64"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
}

data "aws_vpc" "default" {
  default = true
}
# --------------------------------------------------------------

locals {
  # taglie approvate per ambiente (gia' pronta: usala nel TODO 3)
  taglie = {
    dev  = "t3.micro"
    prod = "t3.small"
  }

  # i bucket che il cliente vuole: ruolo => impostazioni (serve al TODO 4)
  bucket = {
    prenotazioni = { versioning = true }
    report       = { versioning = false }
    log          = { versioning = false }
  }

  common_tags = {
    Project    = "PrenotaLab"
    Env        = var.env
    Owner      = var.matricola
    CostCenter = var.cost_center
    ManagedBy  = "Terraform"
  }
}

resource "aws_security_group" "portale" {
  name        = "prenotalab-portale-${var.matricola}"
  description = "Security group del portale PrenotaLab"
  vpc_id      = data.aws_vpc.default.id

  # ============================================================
  # TODO 2 (FASE 1) - la regola HTTP.
  #   Aggiungi un blocco ingress che apra la porta 80 in TCP a
  #   0.0.0.0/0, con una description sensata. Nient'altro:
  #   niente SSH, niente RDP.
  # ============================================================
  ingress {
    description = "Traffico web in entrata"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Tutto in uscita"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(local.common_tags, {
    Name = "prenotalab-sg-${var.matricola}"
  })
}

resource "aws_instance" "portale" {
  ami           = data.aws_ami.al2023.id
  instance_type = local.taglie[var.env] # TODO 3 - usa la mappa local.taglie

  vpc_security_group_ids = [aws_security_group.portale.id]

  user_data_replace_on_change = true
  user_data                   = <<-EOT
    #!/bin/bash
    dnf install -y httpd
    systemctl enable --now httpd
    echo "<h1>PrenotaLab ${var.env} - ${var.matricola}</h1>" > /var/www/html/index.html
  EOT

  tags = merge(local.common_tags, {
    Name      = "prenotalab-portale-${var.matricola}"
    Referente = "segreteria-didattica"
  })
}

# ==============================================================
# TODO 4 (FASE 1) - i bucket, fatti col modulo aziendale.
#   Il cliente vuole i TRE bucket descritti in local.bucket
#   (prenotazioni, report, log), ognuno con la sua impostazione
#   di versioning. Il modulo e' pronto in ./modules/bucket-standard
#   e vuole cinque input: ruolo, env, cost_center, matricola,
#   versioning.
#
#   Scrivi UN SOLO blocco module "bucket" che li crea tutti e tre
#   ciclando sulla mappa local.bucket (niente copia-incolla).
#   L'output a mappa va completato in outputs.tf.
# ==============================================================
module "bucket" {
  source = "./modules/bucket-standard"

  for_each = local.bucket

  ruolo       = each.key
  env         = var.env
  cost_center = var.cost_center
  matricola   = var.matricola
  versioning  = each.value.versioning
}

moved {
  from = aws_instance.web
  to   = aws_instance.portale
}
