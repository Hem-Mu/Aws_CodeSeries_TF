resource "aws_codecommit_repository" "apprepo" {
  repository_name = "minwook-appCodecommit-tf"
  description     = "springBoot repo"
}
output "apprepo_id" {
    value = "${aws_codecommit_repository.apprepo.id}"
  }