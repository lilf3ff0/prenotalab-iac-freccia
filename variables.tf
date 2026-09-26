variable "matricola" {
  description = "Il tuo cognome in minuscolo, senza spazi ne' cifre. Rende unici i nomi delle risorse."
  type        = string

  # ============================================================
  # TODO 1 (FASE 1) - la validation.
  #   Aggiungi qui un blocco validation che accetti SOLO un cognome
  #   in minuscolo: lettere da a a z, da 3 a 20 caratteri, niente
  #   cifre, spazi o maiuscole. Scrivi un error_message chiaro.
  # ============================================================
}

variable "env" {
  description = "Ambiente: dev oppure prod"
  type        = string
  default     = "dev"

  validation {
    condition     = contains(["dev", "prod"], var.env)
    error_message = "L'ambiente puo' essere solo dev o prod."
  }
}

variable "cost_center" {
  description = "Centro di costo, formato CC-<numero>"
  type        = string
  default     = "CC-24"

  validation {
    condition     = can(regex("^CC-[0-9]+$", var.cost_center))
    error_message = "Il cost_center deve avere il formato CC-<numero>, es. CC-24."
  }
}
