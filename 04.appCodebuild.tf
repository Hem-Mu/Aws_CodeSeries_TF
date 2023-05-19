resource "aws_codebuild_project" "codebuild" {
  name          = "minwook-appCodebuild"
  description   = "test_codebuild_project"
  build_timeout = "5"
  service_role  = aws_iam_role.codebuildrole.arn

  artifacts {
    type = "S3"
    location = aws_s3_bucket.appartifactBucket.bucket
    name = "hasmterbuildOutput" # Not applicable when running with pipeline
    path = "/hamster/buildster" # Not applicable when running with pipeline
  }

  cache {
    type     = "S3"
    location = aws_s3_bucket.appartifactBucket.bucket
  }

  environment {
    compute_type                = "BUILD_GENERAL1_SMALL" # https://docs.aws.amazon.com/codebuild/latest/userguide/build-env-ref-compute-types.html
    image                       = "aws/codebuild/amazonlinux2-x86_64-standard:4.0" # https://docs.aws.amazon.com/codebuild/latest/userguide/build-env-ref-available.html
    type                        = "LINUX_CONTAINER" # ARM_CONTAINER | LINUX_CONTAINER | LINUX_GPU_CONTAINER | WINDOWS_CONTAINER | WINDOWS_SERVER_2019_CONTAINER
    image_pull_credentials_type = "CODEBUILD" # When you use a cross-account or private registry image, you must use SERVICE_ROLE credentials. When you use an AWS CodeBuild curated image, you must use CODEBUILD credentials.
  } 
  # https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-properties-codebuild-project-environmentvariable.html

  # logs_config {
  #   cloudwatch_logs {
  #     group_name  = "log-group"
  #     stream_name = "log-stream"
  #   }

  #   s3_logs {
  #     status   = "ENABLED"
  #     location = "${aws_s3_bucket.example.id}/build-log"
  #   }
  # }

  source {
    type            = "CODECOMMIT"
    location = aws_codecommit_repository.apprepo.repository_name
    git_clone_depth = 1
  }

  source_version = "main"

  tags = {
    Owner = "minwook.kim"
  }
}