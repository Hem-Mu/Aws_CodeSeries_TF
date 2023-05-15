resource "aws_codedeploy_app" "deploy" {
  compute_platform = "Server"
  name             = "codedeploy-tf"
}# application




resource "aws_codedeploy_deployment_group" "codedeployDeployGroup" {
  app_name              = aws_codedeploy_app.deploy.name
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









data "aws_iam_policy_document" "deployRoleAssume" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["codedeploy.amazonaws.com"]
    }# establish trust with codedeploy

    actions = ["sts:AssumeRole"]
  }
}
resource "aws_iam_role" "codedeployRole" {
  name               = "HamstercodeDeployRole"
  assume_role_policy = data.aws_iam_policy_document.deployRoleAssume.json
}

resource "aws_iam_role_policy_attachment" "CodeDeployRoleAttach" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSCodeDeployRole"
  role       = aws_iam_role.codedeployRole.name
}