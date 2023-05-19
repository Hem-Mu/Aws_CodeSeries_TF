resource "aws_iam_role" "codebuildrole" {
  name               = "HamsterCodeBuildRole"
  assume_role_policy = data.aws_iam_policy_document.buildroleassume.json
}
resource "aws_iam_policy" "codebuild_policy" {
  name   = "HamsterCodeBuildPolicy"
  policy = data.aws_iam_policy_document.codebuildpolicydoc.json
}
resource "aws_iam_role_policy_attachment" "codebuildroleattach" {
  policy_arn = aws_iam_policy.codebuild_policy.arn
  role       = aws_iam_role.codebuildrole.name
}

data "aws_iam_policy_document" "buildroleassume" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["codebuild.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}# trust 
data "aws_iam_policy_document" "codebuildpolicydoc" {
  statement {
    effect = "Allow"

    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
    ]

    resources = ["*"]
  }
  statement {
    effect = "Allow"

    actions = [
      "ec2:CreateNetworkInterface",
      "ec2:DescribeDhcpOptions",
      "ec2:DescribeNetworkInterfaces",
      "ec2:DeleteNetworkInterface",
      "ec2:DescribeSubnets",
      "ec2:DescribeSecurityGroups",
      "ec2:DescribeVpcs",
    ]

    resources = ["*"]
  }
  statement {
    effect = "Allow"

    actions = [
      "s3:GetObject",
      "s3:GetObjectVersion",
      "s3:GetBucketVersioning",
      "s3:PutObjectAcl",
      "s3:PutObject",
      "s3:ListBucket"
    ]

    resources = [
      "arn:aws:s3:::*",
      "arn:aws:s3:::*/*"
    ]
  }
  statement {
    effect = "Allow"

    actions = [
      "codecommit:GitPull"
    ]

    resources = ["*"]
  }
  statement {
    effect  = "Allow"
    actions = ["s3:*"]
    resources = [
      aws_s3_bucket.appartifactBucket.arn,
      "${aws_s3_bucket.appartifactBucket.arn}/*",
    ]
  }
#   statement {
#     effect    = "Allow"
#     actions   = ["ec2:CreateNetworkInterfacePermission"]
#     resources = ["arn:aws:ec2:us-east-1:123456789012:network-interface/*"]

#     condition {
#       test     = "StringEquals"
#       variable = "ec2:Subnet"

#       values = [
#         aws_subnet.example1.arn,
#         aws_subnet.example2.arn,
#       ]
#     }
#     condition {
#       test     = "StringEquals"
#       variable = "ec2:AuthorizedService"
#       values   = ["codebuild.amazonaws.com"]
#     }
#   } # require docker using
}