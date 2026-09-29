# Test del modulo bucket-standard.
# Girano SENZA creare niente su AWS (command = plan) e SENZA credenziali:
# il provider qui sotto usa chiavi finte, quindi il test gira anche in GitHub Actions.

provider "aws" {
  region                      = "us-east-1"
  access_key                  = "finta"
  secret_key                  = "finta"
  skip_credentials_validation = true
  skip_metadata_api_check     = true
  skip_requesting_account_id  = true
}

variables {
  ruolo       = "prenotazioni"
  env         = "dev"
  cost_center = "CC-24"
  matricola   = "test"
}

# --- esempio gia' scritto -----------------------------------------------
run "il_nome_segue_lo_schema" {
  command = plan

  assert {
    condition     = output.nome == "prenotalab-test-prenotazioni-dev"
    error_message = "Il nome del bucket non segue lo schema prenotalab-<matricola>-<ruolo>-<env>"
  }
}

# ==============================================================
# TODO TEST 1 (FASE 3) - scrivi un run "versioning_acceso_se_richiesto"
#   che, con versioning = true (in dev), verifichi sul PIANO che lo
#   status di aws_s3_bucket_versioning.this sia "Enabled".
#   Suggerimento: versioning_configuration e' un blocco, quindi si
#   legge con versioning_configuration[0].status
# ==============================================================
run "versioning_acceso_se_richiesto" { 
  command = plan
  
  variables {
    versioning = true
  }

  assert {
    condition     = aws_s3_bucket_versioning.this.versioning_configuration[0].status == "Enabled"
    error_message = "In dev, se versioning = true, lo status deve essere Enabled."
  }
}

# ==============================================================
# TODO TEST 2 (FASE 3) - scrivi un run "in_prod_versioning_sempre_acceso"
#   che, con env = "prod" e versioning = false, verifichi che lo
#   status sia comunque "Enabled": in prod lo standard lo impone.
# ==============================================================
run "in_prod_versioning_sempre_acceso" {
  command = plan

  variables {
    env        = "prod"
    versioning = false
  }

  assert {
    condition     = aws_s3_bucket_versioning.this.versioning_configuration[0].status == "Enabled"
    error_message = "In prod, anche se versioning = false, lo status deve essere Enabled."
  }
}
