################### PROVIDER ######################
region     = "us-west-2"
access_key = ""
secret_key = ""

########### VPC ##################
vpc_cidr_block       = "10.0.0.0/16"
enable_dns_support   = false
enable_dns_hostnames = false
vpc_name             = "main_vpc"

####### subnet ############
subnet_name               = "test-subnet"
public_subnet_cidr_block  = "10.0.0.0/24"
private_subnet_cidr_block = "10.0.1.0/24"


######## load balancer #########
app_name    = "application-lb"
server_port = 80


