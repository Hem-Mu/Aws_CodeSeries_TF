resource "aws_codedeploy_app" "webdeploy" {
  compute_platform = "Server"
  name             = "minwook-webCodedeploy-tf"
}

resource "aws_codedeploy_deployment_group" "webcodedeployDeployGroup" {
  app_name              = aws_codedeploy_app.webdeploy.name
  deployment_group_name = "HamstercodedeployDeployGroup"
  service_role_arn      = aws_iam_role.codedeployrole.arn

    autoscaling_groups = [
    data.terraform_remote_state.infra.outputs.webautoscaling_id
  ]

  load_balancer_info {
      target_group_info {
        name = data.terraform_remote_state.infra.outputs.web_target_group_name
      }
  }
  
  # ec2_tag_set {
  #   ec2_tag_filter {
  #     key   = "codedeploy"
  #     type  = "KEY_AND_VALUE"
  #     value = "web"
  #   }
  # }

  auto_rollback_configuration {
    enabled = true
    events  = ["DEPLOYMENT_FAILURE"]
  }

  tags = {
    Owner = "minwook.kim"
  }
}
