# Fastly Demo

This project demonstrates the capabilities of Fastly's edge cloud platform with a simple but effective CDN implementation. It showcases key features of Fastly CDN including caching, edge computing, security controls, and observability.

## Overview

The Fastly Demo implements a Content Delivery Network (CDN) using Fastly's edge cloud platform, demonstrating:

- Content caching and delivery 
- TLS/SSL implementation with Let's Encrypt
- Custom VCL (Varnish Configuration Language) for edge logic
- DNS integration with Cloudflare
- Observability with New Relic logging
- Infrastructure as Code using Terraform

## Architecture

For detailed architecture information, please refer to the [Solution Design Document](docs/design/solution-design.md).

## Features

- **Edge Logic**: Custom VCL for request/response manipulation at the edge
- **TLS/SSL**: Automatic certificate management with Let's Encrypt
- **Security Controls**: 
  - Force HTTPS redirection
  - Geo-blocking capabilities (example: Russia)
  - Bot protection with robots.txt
- **Custom Error Pages**: Custom 404 and 503 error responses
- **Observability**: New Relic logging integration
- **Infrastructure as Code**: Terraform configuration for reproducible deployments

## Getting Started

### Prerequisites

- [Terraform](https://www.terraform.io/downloads.html) (~> 1.0)
- [Fastly Account](https://www.fastly.com/signup) with API key
- [Cloudflare Account](https://dash.cloudflare.com/sign-up) with API token
- A domain name configured in Cloudflare

### Installation

1. Clone this repository:
```bash
git clone <repository-url>
cd fastly-demo
```

2. Create a `tls.tfvars` file with your sensitive variables:
```hcl
fastly_api_key = "your-fastly-api-key"
cloudflare_api_token = "your-cloudflare-api-token" 
newrelic_log_license_key = "your-newrelic-license-key"
```

3. Configure your domain in `vlucaswang.auto.tfvars`:
```hcl
fastly_domains = ["fastly-demo.yourdomain.com"]
tls_domains = ["fastly-demo.yourdomain.com"]
shield = "sjc-ca-us" # Choose your preferred shield POP
```

4. Format Terraform code
```bash
make fmt
```

4. Format VCL code
```bash
make lint
```

6. Initialize Terraform:
```bash
cd cdn/terraform
terraform init
```

7. Review the Terraform plan:
```bash
make plan
```

8. Apply the Terraform configuration:
```bash
make apply
```

### Usage

After deployment, your Fastly service will be accessible at the domain you configured. The service includes:

- Force SSL redirection
- Geo-blocking for specified countries
- Custom error pages
- New Relic logging
- Bot protection

## Development

### VCL Files

- `boilerplate.vcl`: Contains standard Fastly VCL configuration
- `addons.vcl`: Contains custom VCL for specific features

### Terraform Structure

The project uses Terraform to manage infrastructure as code. The Terraform configuration is organized as follows:

```
cdn/terraform/
├── main.tf              # Main Terraform configuration for Fastly CDN
├── outputs.tf           # Output values from the Terraform deployment
├── terraform.tf         # Provider configuration and version requirements
├── variables.tf         # Variable definitions for the Terraform configuration
├── vlucaswang.auto.tfvars # Non-sensitive variable values (automatically loaded)
├── tls.tfvars           # Sensitive variables (excluded from version control)
├── files/
│   ├── newrelic_log_format.txt  # Logging format for New Relic integration
│   └── robots.txt               # Custom robots.txt for bot control
└── vcl/
    ├── addons.vcl       # Custom VCL implementations for specific features
    └── boilerplate.vcl  # Standard Fastly VCL configuration
```

#### Key Terraform Files

- `main.tf`: Contains the core Fastly service configuration, including backend definitions, VCL snippets, and logging endpoints
- `variables.tf`: Defines all variables used in the configuration, including Fastly API credentials and domain names
- `outputs.tf`: Defines outputs such as the Fastly service ID and version
- `terraform.tf`: Configures the required Terraform and provider versions

### Makefile Commands

- `make help`: Show available commands
- `make fmt`: Run Terraform format
- `make lint`: Run VCL format
- `make plan`: Generate and show Terraform plan
- `make apply`: Apply Terraform changes
- `make destroy`: Destroy the Fastly service

## Security Features

- **TLS/SSL**: Automatic certificate provisioning and management
- **Force HTTPS**: Redirects HTTP requests to HTTPS
- **Geo-blocking**: Example configuration to block specific countries
- **Bot Protection**: Comprehensive robots.txt to block AI crawlers
