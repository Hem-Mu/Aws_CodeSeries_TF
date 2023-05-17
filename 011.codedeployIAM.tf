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