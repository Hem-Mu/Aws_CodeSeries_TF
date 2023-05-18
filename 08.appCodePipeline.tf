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
  role_arn = aws_iam_role.codepipelinrole.arn # codePipeline Role

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
    name = "Plan"

    action {
      run_order        = 1
      name             = "Codebuild"
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      input_artifacts  = ["SourceOutput"]
      output_artifacts = ["BuildOutput"]
      version          = "1"

      configuration = {
        ProjectName          = aws_codebuild_project.codebuild.name
        EnvironmentVariables = jsonencode([
          {
            name  = "PIPELINE_EXECUTION_ID"
            value = "#{codepipeline.PipelineExecutionId}"
            type  = "PLAINTEXT"
          }
        ])
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
      input_artifacts = ["BuildOutput"]
      version         = "1"

      configuration = {
        ApplicationName  = aws_codedeploy_app.appdeploy.name
        DeploymentGroupName = aws_codedeploy_deployment_group.appcodedeployDeployGroup.deployment_group_name
      }
    }
  }
}# configruation Argument Reference: https://docs.aws.amazon.com/codepipeline/latest/userguide/reference-pipeline-structure.html#action-requirements