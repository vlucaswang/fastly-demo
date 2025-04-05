terraform {
  required_providers {
    fastly = {
      source  = "fastly/fastly"
      version = ">= 6.0.0"
    }
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 5"
    }
  }
  required_version = "~> 1.0"
}

# Configure the Fastly Provider
provider "fastly" {
  api_key = var.fastly_api_key
}

provider "cloudflare" {
  api_token = var.cloudflare_api_token
}
