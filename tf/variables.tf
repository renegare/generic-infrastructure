variable "project" {
  description = "Project name for this setup (allowed characters [a-z0-9-])"
}

variable "environment" {
  description = "Project environment (allowed characters [a-z0-9-])"
}

variable "access_key" {
  description = "AWS access key"
}

variable "access_secret" {
  description = "AWS access key secret"
}

variable "region" {
  description = "AWS region to host in"
}

variable "infra_state_bucket" {
  description = "s3 bucket name to store ecs config etc ..."
}

variable "version" {
  description = "git branch-version of the configuration"
}

variable "proxy_image_version" {
  default = "renegare/devops-proxy:a399e23"
}

variable "proxy_port" {
  description = "Port elb should route traffic through to the proxy"
  default     = 8080
}

variable "healthcheck_port" {
  description = "Port proxy should expose the heathcheck endpoint on"
  default     = 3000
}

variable "max_instances" {
  description = "maximum number of instances to launch"
  default     = 1
}

variable "min_instances" {
  description = "minimum number of instances to launch"
  default     = 1
}

variable "desired_instances" {
  description = "desired number of instances"
  default     = 1
}

variable "ec2_public_key" {
  default     = "./ec2_rsa.pub"
}

variable "ami" {
  description = "AWS ECS Weave AMIs"
  default = {
    us-east-1 = "ami-49617b23"
    us-west-1 = "ami-24057b44"
    us-west-2 = "ami-3cac5c5c"
    eu-west-1 = "ami-1025aa63"
    eu-central-1 = "ami-e010f38f"
    ap-northeast-1 = "ami-54d5cc3a"
    ap-southeast-1 = "ami-664d9905"
    ap-southeast-2 = "ami-c2e9c4a1"
  }
}

variable "instance_type" {
  default = "t2.medium"
}

variable "db_name" {
  default = "XXXXXX"
}

variable "db_user" {
  default = "XXXXXX"
}

variable "db_pass" {
  default = "XXXXXX"
}

/*
 For updates to list of available amis go to: http://docs.aws.amazon.com/AmazonECS/latest/developerguide/launch_container_instance.html
 IDE find a replace regex to convert list: (-\d).+(ami-[a-z0-9]+) > $1 = "$2"
 */
