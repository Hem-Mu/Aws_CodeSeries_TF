resource "aws_instance" "appServer" {
  ami           = "ami-035da6a0773842f64" # amazon linux2
  instance_type = "t3.small"
  subnet_id   =  data.terraform_remote_state.network.outputs.pri1_id
  key_name = data.terraform_remote_state.network.outputs.keypair
  vpc_security_group_ids = [aws_security_group.appServerSG.id] # 보안그룹
  iam_instance_profile   = aws_iam_instance_profile.instance_profile.name # IAM
  
  tags = {
    Name = "minwook.kim-deployServer"
    Owner = "minwook.kim"
    codedeploy = "app"
  }

  user_data = "${file("./java17Install.sh")}"
}







resource "aws_security_group" "appServerSG" {
  name        = "appServerSG"
  description = "appServerSG"
  vpc_id      = data.terraform_remote_state.network.outputs.vpc_id

  ingress {
    description      = "bastion to appServer"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    security_groups = [aws_security_group.bastinSG.id] #source SG
  }
  ingress {
    description      = "tomcat"
    from_port        = 8080
    to_port          = 8080
    protocol         = "tcp"
    security_groups = ["0.0.0.0/0"] #source SG
  }


  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = "minwook.kim-appServerSG"
    Owner = "minwook.kim"
  }
}









data "aws_iam_policy_document" "EC2RoleAssume" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }# establish trust with codedeploy

    actions = ["sts:AssumeRole"]
  }
}
resource "aws_iam_role" "EC2codedeployRole" {
  name               = "HamsterEC2codedeployRole"
  assume_role_policy = data.aws_iam_policy_document.EC2RoleAssume.json
}
resource "aws_iam_role_policy_attachment" "EC2CodeDeployRoleAttach" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2RoleforAWSCodeDeploy"
  role       = aws_iam_role.EC2codedeployRole.name
}
resource "aws_iam_instance_profile" "instance_profile" {
  name = "HamsterEC2codedeployRole"
  role = aws_iam_role.EC2codedeployRole.name
}











output "deployServerSG_id" {
    value = "${aws_security_group.deployServerSG.id}"
  }
