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

# Assignment 5

variable "app_sec_group"{
    type= list
    default=[]
}

variable "app_ports_ingress"{
    type=list
    default=[22,443,80,3000]
}

variable "app_ports_egress"{
    type=list
    default=[0,3306]
}

variable "db_ports_ingress"{
    type=list
    default=[3306]
}

variable "db_ports_egress"{
    type=list
    default=[0]
}

variable "pub_v4_block"{
    type = list
    default=["0.0.0.0/0"]
}

variable "pub_v6_block"{
    type = list
    default=["::/0"]
}

variable "tcp" {
    type = string
    default="tcp"
}

variable "app_name" {
    type = string
    default = "application"
}
variable "db_name" {
    type = string
    default = "database"
}

variable "s3_vars"{
    type = "map"

    default = {
        bucket = "webapp.dharmik.harkhani"
        acl = "private"
        lf_enabled= true
        trans_days = 30
        trans_storage_class = "STANDARD_IA"
        force_destroy = true
        versioning = true
        env = "prod"
        algo="AES256"
    }
}

variable "rds_subnet_grp" {
    type = string
    default = "dbsubnetgroup"
}

variable "rds_config" {
    type = map

    default = {
        allocated_storage    = 20
        storage_type         = "gp2"
        engine               = "mysql"
        engine_version       = "5.7"
        instance_class       = "db.t3.micro"
        multi_az             = false
        identifier           = "csye6225-f20"
        name                 = "webapp_database"
        username             = "csye6225fall2020"
        password             = "Dharmik$123"
        parameter_group_name = "default.mysql5.7"
        publicly_accessible  = false
    }
}

variable "iam_profile" {
    type = string
    default = "ec2_s3_profile"
}