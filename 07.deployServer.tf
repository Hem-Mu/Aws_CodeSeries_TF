resource "aws_instance" "deployServer" {
  ami           = "ami-0fd48c6031f8700df" # centos
  instance_type = "t2.medium"
  subnet_id   =  data.terraform_remote_state.network.outputs.pri1_id
  key_name = data.terraform_remote_state.network.outputs.keypair
  vpc_security_group_ids = [aws_security_group.deployServerSG.id] # 보안그룹
  
  tags = {
    Name = "deployServer"
  }
  user_data = "${file("./cdAgent.sh")}"
}
resource "aws_eip" "deployServerIP" {
  instance = aws_instance.deployServer.id
  vpc      = true
}

resource "aws_security_group" "deployServerSG" {
  name        = "deployServerSG"
  description = "deployServerSG"
  vpc_id      = data.terraform_remote_state.network.outputs.vpc_id

  tags = {
    Name = "deployServerSG"
  }
}

resource "aws_security_group_rule" "deployServerSG_in" {
  type              = "ingress"
  from_port         = 0
  to_port           = 0
  protocol          = "all" # all, TCP, UDP
  cidr_blocks       = ["211.205.9.172/32"]
  security_group_id = "${aws_security_group.web.id}"

  lifecycle { 
    create_before_destroy = true 
    } # 생성 후 삭제
} # all inbound
resource "aws_security_group_rule" "deployServerSG_out" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "all"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.web.id}"

  lifecycle { 
    create_before_destroy = true 
    } # 생성 후 삭제
} # all outbound
resource "aws_security_group_rule" "icmp" {
  type              = "ingress"
  from_port         = -1
  to_port           = -1
  protocol          = "icmp" # all, TCP, UDP
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.web.id}"

  lifecycle { 
    create_before_destroy = true 
    } # 생성 후 삭제
} # all inbound icmp

output "deployServerSG_id" {
    value = "${aws_security_group.deployServerSG.id}"
  }
