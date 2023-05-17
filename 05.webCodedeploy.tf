resource "aws_codedeploy_app" "webdeploy" {
  compute_platform = "Server"
  name             = "minwook-webCodedeploy-tf"
}# application




resource "aws_codedeploy_deployment_group" "webcodedeployDeployGroup" {
  app_name              = aws_codedeploy_app.webdeploy.name
  deployment_group_name = "HamstercodedeployDeployGroup"
  service_role_arn      = aws_iam_role.codedeployRole.arn

  ec2_tag_set {
    ec2_tag_filter {
      key   = "Code"
      type  = "KEY_AND_VALUE"
      value = "Deploy"
    }
  }

  auto_rollback_configuration {
    enabled = true
    events  = ["DEPLOYMENT_FAILURE"]
  }

  tags = {
    Owner = "minwook.kim"
  }
}