resource "aws_s3_bucket" "appartifactBucket" {
  bucket = "minwook.kim-appcodepipeline-s3" # only lowercase
  force_destroy = true

  tags = {
    Name = "minwook.kim-appcodePipeline-S3"
    Owner = "minwook.kim"
  }
}










resource "aws_codepipeline" "appcodepipeline" {
  name     = "minwook-appCodepipeline-tf"
  role_arn = aws_iam_role.codePipelinRole.arn # codePipeline Role

  artifact_store {
    location = aws_s3_bucket.appartifactBucket.bucket
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
        RepositoryName    = aws_codecommit_repository.apprepo.repository_name # webCodeCommit
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
        ApplicationName  = aws_codedeploy_app.appdeploy.name
        DeploymentGroupName = aws_codedeploy_deployment_group.appcodedeployDeployGroup.deployment_group_name
      }
    }
  }
}# configruation Argument Reference: https://docs.aws.amazon.com/codepipeline/latest/userguide/reference-pipeline-structure.html#action-requirements