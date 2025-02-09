# terraform {
  # backend "s3" {
  #   bucket = "your-space-name"     # DigitalOcean Space name
  #   region = "nyc3"                # Space region (e.g., nyc3, sfo2)
  #   key    = "path/to/statefile.tfstate"  # Path within the Space (e.g., `myproject/terraform.tfstate`)
  #   access_key = "your-access-key"  # DigitalOcean access key
  #   secret_key = "your-secret-key"  # DigitalOcean secret key
  #   endpoint = "nyc3.digitaloceanspaces.com"  # Endpoint for DigitalOcean Spaces (nyc3, sfo2, etc.)
  #   acl = "private"               # Make the state file private
  # }
# }

# Variables

variable "netlify_access_token" {
  description = "Netlify access token"
  type        = string
  default     = ""
}

variable "frontend_build_dir" {
  description = "Build dir for local provider"
  type        = string
  default     = ""
}

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
resource "null_resource" "netlify_deploy" {
  provisioner "local-exec" {
    # command = "chmod +x $BASE_DIR/deploy.sh && source deploy.sh"
    command = "ls $FRONTEND_BUILD_DIR -alh"
    environment = {
      NETLIFY_ACCESS_TOKEN = var.netlify_access_token
      FRONTEND_BUILD_DIR = var.frontend_build_dir
    }
  }
}
