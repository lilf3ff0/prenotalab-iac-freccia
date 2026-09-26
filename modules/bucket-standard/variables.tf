variable "ruolo" {
  description = "A cosa serve il bucket (prenotazioni, report, log...)"
  type        = string
}

variable "env" {
  description = "Ambiente: dev o prod"
  type        = string

  validation {
    condition     = contains(["dev", "prod"], var.env)
    error_message = "L'ambiente puo' essere solo dev o prod."
  }
}

variable "cost_center" {
  description = "Centro di costo, formato CC-<numero>"
  type        = string

  validation {
    condition     = can(regex("^CC-[0-9]+$", var.cost_center))
    error_message = "Il cost_center deve avere il formato CC-<numero>, es. CC-24."
  }
}

variable "matricola" {
  description = "Suffisso univoco (il cognome dello studente)"
  type        = string
}

variable "versioning" {
  description = "true = versioning acceso anche in dev. In prod e' sempre acceso."
  type        = bool
  default     = false
}
