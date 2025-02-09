# The below has been tested, and works well

terraform {
  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "~> 2.0"
    }
    supabase = {
      source  = "supabase/supabase"
      version = "1.5.1"
    }
    # Netlify does not allow to deploy sites via its provider
    # netlify = {
    #   source  = "netlify/netlify"
    #   version = "~> 0.2.2"
    # }
  }

  # backend "s3" {
  #   bucket = "your-space-name"     # DigitalOcean Space name
  #   region = "nyc3"                # Space region (e.g., nyc3, sfo2)
  #   key    = "path/to/statefile.tfstate"  # Path within the Space (e.g., `myproject/terraform.tfstate`)
  #   access_key = "your-access-key"  # DigitalOcean access key
  #   secret_key = "your-secret-key"  # DigitalOcean secret key
  #   endpoint = "nyc3.digitaloceanspaces.com"  # Endpoint for DigitalOcean Spaces (nyc3, sfo2, etc.)
  #   acl = "private"               # Make the state file private
  # }
}

# Variables

# variable "netlify_access_token" {
#   description = "Netlify access token"
#   type        = string
#   default     = ""
# }

# variable "netlify_site_name" {
#   type = string
# }

# variable "netlify_custom_domain" {
#   type = string
# }

# Providers
# provider "netlify" {
#   token = var.netlify_access_token
# }

# 1. Create a Netlify site
# Since netlify does not offer a proper provider to deploy sites,
# then we need to use the local provider
# resource "null_resource" "netlify_deploy" {
#   provisioner "local-exec" {
#     command = "netlify sites:create --name ciauu --account-slug tgirotto"
#     environment = {
#       NETLIFY_AUTH_TOKEN = var.netlify_access_token
#     }
#   }
# }
