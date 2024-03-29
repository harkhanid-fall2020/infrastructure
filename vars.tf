# VPC variables 
 variable "region" {
     default = "us-east-1"
 }

 variable "ami" {
     default= "ami-0957aa17f43007d7c"
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
        storage_encrypted    = true
        identifier           = "csye6225-f20"
        name                 = "webapp_database"
        parameter_group_name = "default.mysql5.7"
        publicly_accessible  = false
    }
}

variable "dbUsername" {
  type= string
  default = ""
}

variable "dbPassword" {
  type = string
  default = ""
}

variable "iam_profile" {
    type = string
    default = "ec2_s3_profile"
}

variable "ec2_config"{
    type = map
    default = {
        ami = "ami-0fb2d8a51156ea1fc"
        associate_public_ip_address = true
        instance_type = "t2.micro"
        delete_on_termination = true
        device_name = "/dev/sdf"
        volume_type = "gp2"
        volume_size = 20
        encrypted = false
        name = "webapp"
        key_name = "csye6225_prod_aws"
    }
}

variable "dynamoDB_config" {
    type = "map"
    default = {
        name = "csye6225"
        hash_key = "id"
        billing_mode = "PROVISIONED"
        read_capacity = 5
        write_capacity = 5
        nameid = "id"
        type = "S"
    }
}

variable "codedeploy_app_name" {
    type="string"
    default="csye6225-webapp"
}

variable "accountNumber" {
    type="string"
    default=""
}

variable "codedeploybucket" {
    type="string"
    default="codedeploy.prod.dharmikharkhani.me"
}

variable "dns_config" {
    type = "map"
    default = {
        zone_id = "Z0730370Q1R2W0D4TOJY"
        name = "api.prod.dharmikharkhani.me"
        type = "CNAME"
        ttl = "300"
    }
}

variable "alias" {
    type = "map"
    default = {
        name="prod.dharmikharkhani.me"
        type="A"
    }
}

variable "auto_scaling_config" {
  type = "map"
  default = {
      instance_type="t2.micro"
  }
}

variable "auto_scaling_group" {
    type = "map"
    default = {
        health_check_type = "EC2"
        health_check_grace_period = 300
        min_size = 3
        max_size = 5
        desired_capacity = 3
    }
}

variable "scaleup_policy" {
    type = "map"
    default = {
        name = "WebAppScaleUp"
        scaling_adjustment = 1
        adjustment_type = "ChangeInCapacity"
        cooldown = 60
    }
}

variable "scaledown_policy" {
    type = "map"
    default = {
        name = "WebAppScaleDown"
        scaling_adjustment = -1
        adjustment_type = "ChangeInCapacity"
        cooldown = 60
    }
}


variable "scaleUpAlert" {
    type = "map"
    default = {
        alarm_name = "highMetricAlarm"
        comparison_operator = "GreaterThanOrEqualToThreshold"
        evaluation_periods = "2"
        metric_name = "CPUUtilization"
        namespace = "AWS/EC2"
        period = "120"
        statistic = "Average"
        threshold = "5"
        alarm_description = "It will give alarm if EC2 CPU utilization is high"
    }
}



variable "scaledownAlert" {
    type = "map"
    default = {
        alarm_name = "lowMetricAlarm"
        comparison_operator = "LessThanOrEqualToThreshold"
        evaluation_periods = "2"
        metric_name = "CPUUtilization"
        namespace = "AWS/EC2"
        period = "120"
        statistic = "Average"
        threshold = "3"
        alarm_description = "It will give alarm if EC2 CPU utilization is high"
    }
}

variable "lb_config" {
    type = "map"
    default = {
        name               = "webapp-lb"
        load_balancer_type = "application"
        internal           = false 
        protocol = "HTTPS"
        port = 443
    }
}

variable "tg_config" {
    type = "map"
    default = {
        name     = "webapp-tg"
        port     = 3000
        protocol = "HTTP"
    }
}

variable "upLimit" {
    type = "string"
    default = "5"
} 

variable "downLimit" {
    type = "string"
    default = "3"
} 
