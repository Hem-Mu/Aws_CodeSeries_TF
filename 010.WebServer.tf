resource "aws_instance" "webServer" {
  ami           = "ami-035da6a0773842f64" # amazon linux2
  instance_type = "t3.small"
  subnet_id   =  data.terraform_remote_state.network.outputs.pri1_id
  key_name = data.terraform_remote_state.network.outputs.keypair
  vpc_security_group_ids = [aws_security_group.webServerSG.id] # 보안그룹
  iam_instance_profile   = aws_iam_instance_profile.instance_profile.name # IAM
  
  tags = {
    Name = "minwook.kim-webServer"
    Owner = "minwook.kim"
    codedeploy = "web"
  }

  user_data = "${file("./codedeployAgentInstall.sh")}"
}







resource "aws_security_group" "webServerSG" {
  name        = "webServerSG"
  description = "webServerSG"
  vpc_id      = data.terraform_remote_state.network.outputs.vpc_id

  ingress {
    description      = "bastion to webServer"
    from_port        = var.sshport
    to_port          = var.sshport
    protocol         = "tcp"
    security_groups = [aws_security_group.bastinSG.id] #source SG
  }


  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = "minwook.kim-deployServerSG"
    Owner = "minwook.kim"
  }
  lifecycle {
    create_before_destroy = true
  }
}
output "webServerSG_id" {
    value = "${aws_security_group.webServerSG.id}"
  }
