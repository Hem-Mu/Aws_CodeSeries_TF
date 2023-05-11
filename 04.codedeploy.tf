resource "aws_codedeploy_app" "deploy" {
  compute_platform = "Server"
  name             = "codedeploy-tf"
}# application