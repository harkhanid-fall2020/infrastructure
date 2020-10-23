#!/bin/bash
sudo chmod 777 /etc/environment
sudo echo 'db_user="webapp_database"' >> /etc/environment
sudo echo 'db_username="${ var.rds_config.username}"' >> /etc/environment
sudo echo 'db_password="${var.rds_config.password}"' >> /etc/environment
sudo echo 'db_name="${var.rds_config.name}"' >> /etc/environment
sudo echo 'db_host="${aws_db_instance.default.endpoint }"' >> /etc/environment
sudo echo 's3_bucket="${var.s3_vars.bucket }"' >> /etc/environment
sudo echo 's3_region="${var.region }"' >> /etc/environment