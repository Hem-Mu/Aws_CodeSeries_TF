data "aws_iam_policy_document" "EC2RoleAssume" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }# establish trust with codedeploy

    actions = ["sts:AssumeRole"]
  }
}
resource "aws_iam_role" "EC2codedeployRole" {
  name               = "HamsterEC2codedeployRole"
  assume_role_policy = data.aws_iam_policy_document.EC2RoleAssume.json
}
resource "aws_iam_role_policy_attachment" "EC2CodeDeployRoleAttach" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2RoleforAWSCodeDeploy"
  role       = aws_iam_role.EC2codedeployRole.name
}
resource "aws_iam_instance_profile" "instance_profile" {
  name = "HamsterEC2codedeployRole"
  role = aws_iam_role.EC2codedeployRole.name
}