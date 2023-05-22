resource "aws_codedeploy_app" "webdeploy" {
  compute_platform = "Server"
  name             = "minwook-webCodedeploy-tf"
}# application




resource "aws_codedeploy_deployment_group" "webcodedeployDeployGroup" {
  app_name              = aws_codedeploy_app.webdeploy.name
  deployment_group_name = "HamstercodedeployDeployGroup"
  service_role_arn      = aws_iam_role.codedeployrole.arn

  ec2_tag_set {
    ec2_tag_filter {
      key   = "codedeploy"
      type  = "KEY_AND_VALUE"
      value = "web"
    }
  }

  auto_rollback_configuration {
    enabled = true
    events  = ["DEPLOYMENT_FAILURE"] # DEPLOYMENT_FAILURE | DEPLOYMENT_STOP_ON_ALARM
  }

  tags = {
    Owner = "minwook.kim"
  }
}