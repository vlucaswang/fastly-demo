output "cdn_url" {
  description = "The endpoints created for the fastly services"
  value       = formatlist("https://%s", var.fastly_domains)
}

output "service_id" {
  description = "The fastly service identifier created"
  value       = fastly_service_vcl.this_service.id
}
