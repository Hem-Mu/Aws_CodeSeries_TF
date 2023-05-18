resource "aws_iam_role" "codedeployrole" {
  name               = "HamsterCodeDeployRole"
  assume_role_policy = data.aws_iam_policy_document.deployroleassume.json
}
resource "aws_iam_role_policy_attachment" "codedeployroleattach" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSCodeDeployRole" # aws managed role
  role       = aws_iam_role.codedeployrole.name
}
data "aws_iam_policy_document" "deployroleassume" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["codedeploy.amazonaws.com"]
    }# establish trust with codedeploy

    actions = ["sts:AssumeRole"]
  }
}