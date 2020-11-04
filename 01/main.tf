provider "aws" {
    region = var.region
}

resource "aws_vpc" "vpc_webapp" {
    cidr_block              = var.vpc_cidr
    enable_dns_hostnames    = true
    enable_dns_support      = true
    enable_classiclink_dns_support = true
    assign_generated_ipv6_cidr_block = false
    tags = {
        Name = var.vpc_name
    }
}

resource "aws_subnet" "subnet1" {
    cidr_block = var.subnets_cidr[0]
    vpc_id = aws_vpc.vpc_webapp.id
    availability_zone = var.subnets_az[0]
    map_public_ip_on_launch = true
    tags ={
        Name = var.subnets_name[0]
    }
}

resource "aws_subnet" "subnet2" {
    cidr_block = var.subnets_cidr[1]
    vpc_id = aws_vpc.vpc_webapp.id
    availability_zone = var.subnets_az[1]
    map_public_ip_on_launch = true
    tags ={
      Name = var.subnets_name[1]
    }
}

resource "aws_subnet" "subnet3" {
    cidr_block = var.subnets_cidr[2]
    vpc_id = aws_vpc.vpc_webapp.id
    availability_zone = var.subnets_az[2]
    map_public_ip_on_launch = true
    tags ={
      Name = var.subnets_name[2]
    }
}

# creating internet gateway
resource "aws_internet_gateway" "vpc_igw" {
  vpc_id = aws_vpc.vpc_webapp.id
  tags = {
    "Name" = var.gateway_name
  }
}

# creating route table
resource "aws_route_table" "web-public-route" {
  vpc_id = aws_vpc.vpc_webapp.id
  route {
      cidr_block = var.public_cidr_route
      gateway_id = aws_internet_gateway.vpc_igw.id
  }
  tags = {
    "Name" = var.route_table_name
  }
}

# creating routes for subnets

resource "aws_route_table_association" "artp1" {
  subnet_id = aws_subnet.subnet1.id
  route_table_id = aws_route_table.web-public-route.id
}

resource "aws_route_table_association" "artp2" {
  subnet_id = aws_subnet.subnet2.id
  route_table_id = aws_route_table.web-public-route.id
}

resource "aws_route_table_association" "artp3" {
  subnet_id = aws_subnet.subnet3.id
  route_table_id = aws_route_table.web-public-route.id
}

# creating security group.
# creating security group.
resource "aws_security_group" "application" {
  name        = var.app_name
  description = var.app_name
  vpc_id      = aws_vpc.vpc_webapp.id 

  ingress {
    from_port   = var.app_ports_ingress[0]
    to_port     = var.app_ports_ingress[0]
    protocol    = var.tcp
    cidr_blocks = var.pub_v4_block
  }

  ingress {
    from_port   = var.app_ports_ingress[1]
    to_port     = var.app_ports_ingress[1]
    protocol    = var.tcp
    cidr_blocks = var.pub_v4_block
  }

  ingress {
    from_port   = var.app_ports_ingress[2]
    to_port     = var.app_ports_ingress[2]
    protocol    = var.tcp
    cidr_blocks = var.pub_v4_block
  }

  ingress {
    from_port   = var.app_ports_ingress[3]
    to_port     = var.app_ports_ingress[3]
    protocol    = var.tcp
    cidr_blocks = var.pub_v4_block
  }

  ingress {
    from_port   = var.app_ports_ingress[0]
    to_port     = var.app_ports_ingress[0]
    protocol    = var.tcp
    ipv6_cidr_blocks = var.pub_v6_block
  }

 ingress {
    from_port   = var.app_ports_ingress[1]
    to_port     = var.app_ports_ingress[1]
    protocol    = var.tcp
    ipv6_cidr_blocks = var.pub_v6_block
  }

  ingress {
    from_port   = var.app_ports_ingress[2]
    to_port     = var.app_ports_ingress[2]
    protocol    = var.tcp
    ipv6_cidr_blocks = var.pub_v6_block
  }

  ingress {
    from_port   = var.app_ports_ingress[3]
    to_port     = var.app_ports_ingress[3]
    protocol    = var.tcp
    ipv6_cidr_blocks = var.pub_v6_block
  }
  
  egress {
    from_port   = var.app_ports_egress[0]
    to_port     = var.app_ports_egress[0]
    protocol    = "-1"
    cidr_blocks = var.pub_v4_block
  }

  egress {
    from_port   = var.app_ports_egress[1]
    to_port     = var.app_ports_egress[1]
    protocol    = var.tcp
    cidr_blocks = var.pub_v4_block
  }

  tags = {
    Name = var.app_name
  }
}

resource "aws_security_group" "database" {
  name        = var.db_name
  description = var.db_name
  vpc_id      = aws_vpc.vpc_webapp.id 

  ingress {
    from_port   = var.db_ports_ingress[0]
    to_port     = var.db_ports_ingress[0]
    protocol    = var.tcp
    cidr_blocks = var.pub_v4_block
  } 
  egress {
    from_port   = var.db_ports_egress[0]
    to_port     = var.db_ports_egress[0]
    protocol    = "-1"
    cidr_blocks = var.pub_v4_block
  }

  tags = {
    Name = var.db_name
  }
}

# creating s3 bucket 
  resource "aws_s3_bucket" "webapp_dharmik_harkhani" {
    bucket = var.s3_vars.bucket
    
    acl    = var.s3_vars.acl

    lifecycle_rule {
      enabled = var.s3_vars.lf_enabled
      transition {
        days = var.s3_vars.trans_days
        storage_class = var.s3_vars.trans_storage_class
      }
    }
    force_destroy = var.s3_vars.force_destroy
        
    versioning {
      enabled = var.s3_vars.versioning
    }
    
    tags = {
    Name        = var.s3_vars.bucket
    Environment = var.s3_vars.env
  }

    server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = var.s3_vars.algo
      }
    }
  }
 }

# creating RDS instance
resource "aws_db_subnet_group" "db-subnet-group" {
name = var.rds_subnet_grp
subnet_ids = [aws_subnet.subnet1.id,aws_subnet.subnet2.id]
}



resource "aws_db_instance" "default" {
  allocated_storage    = var.rds_config.allocated_storage
  storage_type         = var.rds_config.storage_type
  engine               = var.rds_config.engine
  engine_version       = var.rds_config.engine_version
  db_subnet_group_name = aws_db_subnet_group.db-subnet-group.id
  instance_class       = var.rds_config.instance_class
  multi_az             = var.rds_config.multi_az
  identifier           = var.rds_config.identifier
  name                 = var.rds_config.name
  username             = var.rds_config.username
  password             = var.rds_config.password
  parameter_group_name = var.rds_config.parameter_group_name
  publicly_accessible  = var.rds_config.publicly_accessible
  vpc_security_group_ids = [aws_security_group.database.id]
  skip_final_snapshot	= true
}

resource "aws_iam_role_policy" "WebAppS3" {
  name        = "WebAppS3"
  role = aws_iam_role.Ec2_CSYE6225.name

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": [
                "s3:DeleteObject",
                "s3:GetObject",
                "s3:ListBucket",
                "s3:PutObject",
                "s3:PutObjectAcl"
            ],
            "Effect": "Allow",
            "Resource": [
                "arn:aws:s3:::${var.s3_vars.bucket}",
                "arn:aws:s3:::${var.s3_vars.bucket}/*"
            ]
        }
    ]
}
EOF
}

resource "aws_iam_role_policy" "CodeDeploy-EC2-S3" {
  name        = "CodeDeploy-EC2-S3"
  role = aws_iam_role.Ec2_CSYE6225.name

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": [
                "s3:Get*",
                "s3:List*"
            ],
            "Effect": "Allow",
            "Resource": [
              "arn:aws:s3:::${var.codedeploybucket}",
              "arn:aws:s3:::${var.codedeploybucket}/*"
              ]
        }
    ]
}
EOF
}


resource "aws_iam_role" "Ec2_CSYE6225" {
  name = "EC2-CSYE6225"
 assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_instance_profile" "ec2_s3profile" {
  name = "ec2_s3_profile"
  role = aws_iam_role.Ec2_CSYE6225.name
}

resource "aws_instance" "ec2webapp" {
  ami                           = var.ami
  vpc_security_group_ids        = [aws_security_group.application.id]
  associate_public_ip_address   = var.ec2_config.associate_public_ip_address
  instance_type                 = var.ec2_config.instance_type
  subnet_id = aws_subnet.subnet1.id
  ebs_block_device {
    delete_on_termination = var.ec2_config.delete_on_termination
    device_name = var.ec2_config.device_name
    volume_type = var.ec2_config.volume_type
    volume_size = var.ec2_config.volume_size
    encrypted = var.ec2_config.encrypted
  }
  tags = {
    "Name" = var.ec2_config.name
  }
  iam_instance_profile = aws_iam_instance_profile.ec2_s3profile.id
  key_name = var.ec2_config.key_name
  user_data = <<EOF
#!/bin/bash
sudo chmod 777 /etc/environment
sudo echo 'db_user="webapp_database"' >> /etc/environment
sudo echo 'db_username="${ var.rds_config.username}"' >> /etc/environment
sudo echo 'db_password="${var.rds_config.password}"' >> /etc/environment
sudo echo 'db_name="${var.rds_config.name}"' >> /etc/environment
sudo echo 'db_host="${aws_db_instance.default.endpoint }"' >> /etc/environment
sudo echo 's3_bucket="${var.s3_vars.bucket }"' >> /etc/environment
sudo echo 's3_region="${var.region }"' >> /etc/environment
EOF
}


# dynamoDB table
resource "aws_dynamodb_table" "demoCheck" {
  name = var.dynamoDB_config.name
  hash_key = var.dynamoDB_config.hash_key
  billing_mode = var.dynamoDB_config.billing_mode
  read_capacity = var.dynamoDB_config.read_capacity
  write_capacity = var.dynamoDB_config.write_capacity
  attribute {
    name = var.dynamoDB_config.nameid
    type = var.dynamoDB_config.type
  }
}

# Policy for Ghactions users
resource "aws_iam_policy" "uploadToS3Policy" {
  name = "GH-Upload-To-S3"
  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "s3:PutObject",
                "s3:Get*",
                "s3:List*"
            ],
            "Resource": [
                "arn:aws:s3:::${var.codedeploybucket}",
                "arn:aws:s3:::${var.codedeploybucket}/*"
            ]
        }
    ]
}
EOF
}

resource "aws_iam_user_policy_attachment" "name" {
  user="cicd"
  policy_arn = aws_iam_policy.uploadToS3Policy.arn
}

resource "aws_iam_user_policy" "GH-Code-Deploy" {
  name = "GH-Code-Deploy"
  user = "cicd"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "codedeploy:RegisterApplicationRevision",
        "codedeploy:GetApplicationRevision"
      ],
      "Resource": [
        "arn:aws:codedeploy:${var.region}:${var.accountNumber}:application:${var.codedeploy_app_name}"
      ]
    },
    {
      "Effect": "Allow",
      "Action": [
        "codedeploy:CreateDeployment",
        "codedeploy:GetDeployment"
      ],
      "Resource": [
        "arn:aws:codedeploy:${var.region}:${var.accountNumber}:deploymentgroup:csye6225-webapp/csye6225-webapp-deployment"
      ]
    },
    {
      "Effect": "Allow",
      "Action": [
        "codedeploy:GetDeploymentConfig"
      ],
      "Resource": [
        "arn:aws:codedeploy:${var.region}:${var.accountNumber}:deploymentconfig:CodeDeployDefault.OneAtATime",
        "arn:aws:codedeploy:${var.region}:${var.accountNumber}:deploymentconfig:CodeDeployDefault.HalfAtATime",
        "arn:aws:codedeploy:${var.region}:${var.accountNumber}:deploymentconfig:CodeDeployDefault.AllAtOnce"
      ]
    }
  ]
}
EOF
}


# policy for Amazon code deploy
resource "aws_iam_role" "CodeDeployServiceRole" {
  name = "CodeDeployServiceRole"
 assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "",
            "Effect": "Allow",
            "Principal": {
                "Service": [
                    "codedeploy.amazonaws.com"
                ]
            },
            "Action": "sts:AssumeRole"
        }
    ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "codeploy_role_attachment" {
  role = aws_iam_role.CodeDeployServiceRole.id
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSCodeDeployRole"
}

# Creating CodeDeploy Application and Development Group
resource "aws_codedeploy_app" "csye6225-webapp" {
  compute_platform = "Server"
  name="csye6225-webapp"
}

resource "aws_codedeploy_deployment_group" "csye6225-webapp-deployment" {
  app_name = aws_codedeploy_app.csye6225-webapp.name
  deployment_group_name ="csye6225-webapp-deployment"
  service_role_arn = aws_iam_role.CodeDeployServiceRole.arn
  ec2_tag_set {
    ec2_tag_filter {
      key   = "Name"
      type  = "KEY_AND_VALUE"
      value = var.ec2_config.name
    }
  }
}

# DNS IP EC2 Attachment
resource "aws_route53_record" "www" {
  zone_id = "Z0730370Q1R2W0D4TOJY"
  name    = "api.prod.dharmikharkhani.me"
  type    = "A"
  ttl     = "300"
  records = [aws_instance.ec2webapp.public_ip]
}
