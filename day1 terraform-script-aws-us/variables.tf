################### PROVIDER ######################
variable "region" {
  description = "region of deployemnt"
  type        = string
}

variable "access_key" {
  description = "AWS_ACEES_KEY"
  type        = string
}

variable "secret_key" {
  description = "AWS_SECRET_SECRET_KEY"
  type        = string
}

################## NETWORK CONFIG ###################
variable "vpc_cidr_block" {
  description = "The IPv4 CIDR block for the VPC"
  type        = string
}

variable "enable_dns_support" {
  description = "A boolean flag to enable/disable DNS support in the VPC"
  type        = bool
}

variable "enable_dns_hostnames" {
  description = "A boolean flag to enable/disable DNS hostnames in the VPC"
  type        = bool
}

variable "vpc_name" {
  description = "The name to give to the VPC"
  type        = string
}

variable "subnet_name" {
  description = "The subnet name"
  type        = string
}

variable "availability_zones" {
  description = "availability zones"
  type        = number
  default     = 2
}


variable "public_subnet_cidr_block" {
  description = "CIDR block for the public subnet"
  type        = string
}

variable "private_subnet_cidr_block" {
  description = "CIDR block for the private subnet"
  type        = string
}


# variable "is_public_subnet" {
#   description = "If the value is set to true, the subnet will have public access"
#   type        = bool
# }

########## Load balancer ##############
variable "app_name" {
  type = string
}

variable "server_port" {
  type = number
}

