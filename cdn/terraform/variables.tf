variable "fastly_api_key" {
  description = "Fastly API key"
  type        = string
  sensitive   = true
}

variable "cloudflare_zone_id" {
  description = "Cloudflare Zone ID for vlucaswang.com"
  type        = string
  default     = "82c02be30e37a86c08ddee7b271921ce"
}

variable "cloudflare_api_token" {
  description = "Cloudflare API token"
  type        = string
  sensitive   = true
}

variable "fastly_domains" {
  description = "Domain names for Fastly services"
  type        = list(string)
  default     = []
}

variable "tls_domains" {
  description = "Domain names for TLS services"
  type        = list(string)
  default     = []
}

variable "service_force_destroy" {
  description = "Services that are active cannot be destroyed. In order to destroy the Service must be true, otherwise false"
  type        = bool
  default     = true
}

variable "tls_certificate_authority" {
  description = "The entity that issues and certifies the TLS certificates"
  type        = string
  default     = "lets-encrypt"
}

variable "tls_force_update" {
  description = "Always update even when active domains are present"
  type        = bool
  default     = true
}

variable "tls_force_destroy" {
  description = "Always delete even when active domains are present"
  type        = bool
  default     = true
}

variable "shield" {
  type = string
}

variable "request_settings" {
  description = "Settings used to customize Fastly's request in the exposed service handling. Ref: t.ly/gsyr"
  type = list(object({
    name      = string
    force_ssl = bool
  }))
  default = []
}

variable "condition" {
  description = "Conditions used to customize Fastly's request in the exposed service handling. Ref: t.ly/gsyr"
  type = list(object({
    name      = string
    priority  = number
    statement = string
    type      = string
  }))
  default = []
}

variable "response_object" {
  description = "Response objects used to customize Fastly's request in the exposed service handling. Ref: t.ly/gsyr"
  type = list(object({
    name              = string
    content_type      = string
    content           = string
    request_condition = string
    response          = string
    status            = number
  }))
  default = []
}

variable "newrelic_log_license_key" {
  description = "New Relic license key"
  type        = string
  sensitive   = true
}