# ==============================================================
# TODO 5 (FASE 1) - l'indirizzo del portale.
#   Deve restituire una stringa tipo http://54.1.2.3
# ==============================================================
output "url_portale" {
  description = "Indirizzo del portale PrenotaLab"
  value       = "DA COMPLETARE"
}

# ==============================================================
# TODO 4 (FASE 1, seconda parte) - togli il commento e completa:
#   deve restituire una mappa ruolo => nome del bucket, per esempio
#   { log = "prenotalab-rossi-log-dev", ... }
# ==============================================================
# output "bucket_per_ruolo" {
#   description = "Mappa ruolo => nome del bucket"
#   value       = ...
# }

output "sg_id" {
  description = "ID del security group del portale"
  value       = aws_security_group.portale.id
}

output "instance_id" {
  description = "ID dell'istanza del portale"
  value       = aws_instance.web.id
}
