# terraform {
#   backend "gcp_final_task" {
#     bucket = "gcp_final_task"
#     prefix = "terraform/state" 
#   }
#   required_providers {
#     google = {
#       source  = "hashicorp/google"
#       version = "~> 4.0"
#     }
#   }
# }