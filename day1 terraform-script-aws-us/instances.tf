resource "aws_instance" "server" {
  ami           = "ami-0c09c7eb16d3e8e70"
  instance_type = "t2.micro"
  user_data     = file("${path.cwd}//policies/nginx.sh")

  iam_instance_profile        = aws_iam_instance_profile.ec2_instance_profile.name
  vpc_security_group_ids      = [aws_security_group.sg.id]
  associate_public_ip_address = false
  subnet_id                   = aws_subnet.private[0].id

  tags = {
    Name = "test-instance"
  }

  root_block_device {
    volume_type           = "gp3"
    volume_size           = "50"
    delete_on_termination = false
    encrypted             = true
  }
}

resource "aws_iam_role" "ec2_instance_role" {
  name = "ssm-instance-role"
  managed_policy_arns = [
    "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore",
    "arn:aws:iam::aws:policy/AmazonSSMFullAccess",
  ]
  assume_role_policy = file("${path.cwd}/policies/policies.json")
}

resource "aws_iam_instance_profile" "ec2_instance_profile" {
  name = "ssm-instance-pf"
  role = aws_iam_role.ec2_instance_role.name
}


################ SECURITY GROUP ###############
resource "aws_security_group" "sg" {
  name        = "ssm-pr-scg"
  description = "security group rules"
  vpc_id      = aws_vpc.vpc.id
  ingress {
    description = "HTTPS from VPC"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTP from VPC"
    from_port   = var.server_port
    to_port     = var.server_port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# ALB Security Group: Edit to restrict access to the application
resource "aws_security_group" "lb_sg" {
  name        = "security groupe for the LB"
  description = "controls access to the LB"
  vpc_id      = aws_vpc.vpc.id

  ingress {
    protocol    = "tcp"
    from_port   = var.server_port
    to_port     = var.server_port
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "lb_sg"
  }
}
