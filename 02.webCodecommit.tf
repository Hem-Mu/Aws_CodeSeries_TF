resource "aws_codecommit_repository" "webrepo" {
  repository_name = "minwook-webCodecommit-tf"
  description     = "apache repo"
}
output "webrepo_id" {
    value = "${aws_codecommit_repository.webrepo.id}"
  }