# VPC variables 
 variable "region" {
     default = "us-east-1"
 }

 variable "vpc_cidr" {
     default = "10.0.0.0/16"
 }
 
 variable "vpc_name" {
     default = "Webapp-vpc"
 }

# Subnet variables
 variable "subnets_cidr"{
     type = list
     default = ["10.0.0.0/18","10.0.64.0/18","10.0.128.0/18"]
 }

variable "subnets_name"{
     type = list
     default = ["webApp-subnet1","webApp-subnet2","webApp-subnet3"]
 }

 variable "subnets_az"{
     type = list
     default = ["us-east-1a","us-east-1b","us-east-1c"]
}

# Internet Gateway
variable "gateway_name" {
     default = "webApp-igw"
}

variable "public_cidr_route" {
     default = "0.0.0.0/0"
}
variable "route_table_name" {
     default = "web-public-route"
}
