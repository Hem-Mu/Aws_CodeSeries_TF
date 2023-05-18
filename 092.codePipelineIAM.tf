resource "aws_iam_role" "codepipelinrole" {
  name               = "HamstercodePipelineRole"
  assume_role_policy = data.aws_iam_policy_document.pipelinroleassume.json
}
resource "aws_iam_policy" "codepipeline_policy" {
  name   = "HamsterCodepipelinePolicy"
  policy = data.aws_iam_policy_document.codepipelinepolicydoc.json
}
resource "aws_iam_role_policy_attachment" "codepipelineroleattach" {
  policy_arn = aws_iam_policy.codepipeline_policy.arn
  role       = aws_iam_role.codepipelinrole.name
}

data "aws_iam_policy_document" "pipelinroleassume" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["codepipeline.amazonaws.com"]
    }# establish trust with codepipeline

    actions = ["sts:AssumeRole"]
  }
}# trust 
data "aws_iam_policy_document" "codepipelinepolicydoc" {
  
  statement {
    effect = "Allow"

    actions = [
      "codecommit:CancelUploadArchive",
      "codecommit:GetBranch",
      "codecommit:GetCommit",
      "codecommit:GetRepository",
      "codecommit:GetUploadArchiveStatus",
      "codecommit:UploadArchive"
    ]

    resources = ["*"]
  }
  statement {
    effect = "Allow"

    actions = [
      "codebuild:CreateReportGroup",
      "codebuild:CreateReport",
      "codebuild:UpdateReport",
      "codebuild:BatchGetBuilds",
      "codebuild:BatchPutTestCases",
      "codebuild:BatchPutCodeCoverages",
      "codebuild:StartBuild",
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
} # policy