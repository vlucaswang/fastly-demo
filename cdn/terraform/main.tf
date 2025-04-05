# Cloudflare DNS Record

resource "cloudflare_dns_record" "this_validation_dns_record" {
  depends_on = [fastly_tls_subscription.this_service]

  for_each = {
    # The following `for` expression (due to the outer {}) will produce an object with key/value pairs.
    # The 'key' is the domain name we've configured (e.g. a.example.com, b.example.com)
    # The 'value' is a specific 'challenge' object whose record_name matches the domain (e.g. record_name is _acme-challenge.a.example.com).
    for domain in fastly_tls_subscription.this_service.domains :
    domain => element([
      for obj in fastly_tls_subscription.this_service.managed_dns_challenges :
      obj if obj.record_name == "_acme-challenge.${domain}" # We use an `if` conditional to filter the list to a single element
    ], 0)                                                   # `element()` returns the first object in the list which should be the relevant 'challenge' object we need
  }

  zone_id = var.cloudflare_zone_id
  comment = "Fastly demo verification record"
  name    = each.value.record_name
  content = each.value.record_value
  ttl     = 60
  type    = each.value.record_type
}

resource "cloudflare_dns_record" "this_service_dns_record" {
  depends_on = [fastly_tls_subscription_validation.this_service]

  for_each = toset(var.fastly_domains)

  zone_id = var.cloudflare_zone_id
  comment = "Fastly demo service record"
  name    = each.value
  content = element([for dns_record in data.fastly_tls_configuration.this_service.dns_records : dns_record.record_value if dns_record.record_type == "CNAME"], 0)
  ttl     = 600
  type    = "CNAME"
}

# Fastly Service

resource "fastly_service_vcl" "this_service" {
  name = "Fastly demo service"

  dynamic "domain" {
    for_each = var.fastly_domains

    content {
      name    = domain.value
      comment = "${domain.value} service domain"
    }
  }

  backend {
    address = "r.vlucaswang.com"
    name    = "http-test-resources"
    port    = 80
  }

  force_destroy = var.service_force_destroy
}

resource "fastly_tls_subscription" "this_service" {
  domains               = fastly_service_vcl.this_service.domain[*].name
  certificate_authority = var.tls_certificate_authority
  force_update          = var.tls_force_update
  force_destroy         = var.tls_force_destroy
}

data "fastly_tls_configuration" "this_service" {
  id = fastly_tls_subscription.this_service.configuration_id
}

resource "fastly_tls_subscription_validation" "this_service" {
  depends_on      = [cloudflare_dns_record.this_validation_dns_record]
  subscription_id = fastly_tls_subscription.this_service.id
}
