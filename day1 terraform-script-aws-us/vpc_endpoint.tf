locals {
  services = ["com.amazonaws.${var.region}.ec2messages", "com.amazonaws.${var.region}.ssmmessages", "com.amazonaws.${var.region}.ssm"]
}

resource "aws_vpc_endpoint" "endpoints" {
  count             = length(local.services)
  vpc_id            = aws_vpc.vpc.id
  service_name      = local.services[count.index]
  vpc_endpoint_type = "Interface"
}

resource "aws_vpc_endpoint_subnet_association" "sn" {
  count           = length(local.services)
  vpc_endpoint_id = aws_vpc_endpoint.endpoints[count.index].id
  subnet_id       = aws_subnet.private[0].id
}

resource "aws_vpc_endpoint_security_group_association" "sg" {
  count             = length(local.services)
  vpc_endpoint_id   = aws_vpc_endpoint.endpoints[count.index].id
  security_group_id = aws_security_group.sg.id
}