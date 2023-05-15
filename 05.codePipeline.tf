resource "aws_s3_bucket" "artifactBucket" {
  bucket = "minwook.kim-codepipeline-s3" # only lowercase

  tags = {
    Name = "minwook.kim-codePipeline-S3"
    Owner = "minwook.kim"
  }
}










resource "aws_codepipeline" "codepipeline" {
  name     = "codepipeline-tf"
  role_arn = aws_iam_role.codePipelinRole.arn # codePipeline Role

  artifact_store {
    location = aws_s3_bucket.artifactBucket.bucket
    type     = "S3"
  }

  stage {
    name = "Source"

    action {
      name             = "Source"
      category         = "Source"
      owner            = "AWS"
      provider         = "CodeCommit"
      version          = "1"
      output_artifacts = ["SourceOutput"] # next stage input_artifacts

      configuration = {
        RepositoryName    = aws_codecommit_repository.commit.repository_name
        BranchName       = "main"
      }
    }
  }

  stage {
    name = "Deploy"

    action {
      name            = "Deploy"
      category        = "Deploy"
      owner           = "AWS"
      provider        = "CodeDeploy"
      input_artifacts = ["SourceOutput"]
      version         = "1"

      configuration = {
        ApplicationName  = aws_codedeploy_app.deploy.name
        DeploymentGroupName = aws_codedeploy_deployment_group.codedeployDeployGroup.deployment_group_name
      }
    }
  }
}# configruation Argument Reference: https://docs.aws.amazon.com/codepipeline/latest/userguide/reference-pipeline-structure.html#action-requirements














resource "aws_iam_role" "codePipelinRole" {
  name               = "HamstercodePipelineRole"
  assume_role_policy = data.aws_iam_policy_document.pipelinRoleAssume.json
}
data "aws_iam_policy_document" "pipelinRoleAssume" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["codepipeline.amazonaws.com"]
    }# establish trust with codepipeline

    actions = ["sts:AssumeRole"]
  }
}# trust 
data "aws_iam_policy_document" "codepipeline_policy" {
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
      "arn:aws:s3:::minwook.kim-codepipeline-s3",
      "arn:aws:s3:::minwook.kim-codepipeline-s3/*"
    ]
  }

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
        "codedeploy:CreateDeployment",
        "codedeploy:GetApplication",
        "codedeploy:GetApplicationRevision",
        "codedeploy:GetDeployment",
        "codedeploy:GetDeploymentConfig",
        "codedeploy:RegisterApplicationRevision"
    ]

    resources = ["*"]
  }
} # policy
resource "aws_iam_policy" "codepipeline_policy" {
  name   = "HamsterCodepipelinePolicy"
  policy = data.aws_iam_policy_document.codepipeline_policy.json
}
resource "aws_iam_role_policy_attachment" "CodePipelineRoleAttach" {
  policy_arn = aws_iam_policy.codepipeline_policy.arn
  role       = aws_iam_role.codePipelinRole.name
}