resource "aws_codecommit_repository" "commit" {
  repository_name = "codecommit-tf"
  description     = "Test Repository"
}
output "codecommit_id" {
    value = "${aws_codecommit_repository.commit.id}"
  }