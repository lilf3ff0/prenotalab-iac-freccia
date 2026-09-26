# PrenotaLab - infrastruttura come codice

Il sistema con cui l'ITS prenota le aule laboratorio: un portale web su EC2
e tre bucket S3 costruiti con il modulo aziendale `bucket-standard`.

| Percorso | Che cos'e' |
|---|---|
| `main.tf`, `variables.tf`, `outputs.tf` | il progetto, con i TODO della fase 1 |
| `modules/bucket-standard/` | il modulo aziendale: **si usa, non si modifica** (tranne i test) |
| `modules/bucket-standard/tests/` | i test del modulo, da completare nella fase 3 |
| `policies/` | le policy custom di checkov (una da completare) |
| `checkov-gate.yaml` | le regole che la pipeline rende **bloccanti** |
| `.github/workflows/iac-ci.yml` | il gate sulla pull request, da completare |
| `offline_override.tf.esempio` | piano B, **solo** se il Learner Lab non parte |

## Per partire

```
terraform init
terraform plan -var matricola=TUOCOGNOME
```

Il piano funziona anche prima di completare i TODO (2 risorse).
