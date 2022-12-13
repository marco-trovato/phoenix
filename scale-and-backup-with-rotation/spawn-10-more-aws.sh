provider "aws" {
  access_key = "ACCESS_KEY"
  secret_key = "SECRET_KEY"
  region     = "us-west-2"
}

resource "aws_instance" "example" {
  ami           = "ami-0d5d9d301c853a04a"
  instance_type = "t2.micro"

  count = 10

  # automatically set a unique identifier for each instance
  tags = {
    Name = "instance-${count.index}"
  }
}
