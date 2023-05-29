# data "terraform_remote_state" "network" {
#     backend = "local"
#     config = {
#         path = ".././terraform.tfstate"
#     }   
# }
data "terraform_remote_state" "infra" {
  backend = "s3"
  config = {
    bucket = "minwook-terraform-state-bucket"
    key    = "terraform.tfstate"
    region = "ap-northeast-2"
  }
}
