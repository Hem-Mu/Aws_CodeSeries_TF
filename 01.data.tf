# data "terraform_remote_state" "network" {
#     backend = "local"
#     config = {
#         path = ".././terraform.tfstate"
#     }   
# }
data "terraform_remote_state" "network" {
  backend = "s3"
  config = {
    bucket = "minwook-terraform-state-bucket"
    key    = "terraform.tfstate"
    region = "ap-northeast-2"
  }
}
data "terraform_remote_state" "threetier" {
  backend = "s3"
  config = {
    bucket = "minwook-terraform-state-bucket"
    key    = "3tier/terraform.tfstate"
    region = "ap-northeast-2"
  }
}