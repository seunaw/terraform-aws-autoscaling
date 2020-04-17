provider "aws" {
  region = var.region
}

variable "root_block_device" {
  default = [
    {
      volume_size = "8"
      volume_type = "gp2"
    },
  ]
}

variable "ebs_block_device" {
  default = [
    {
      device_name           = "/dev/xvdz"
      volume_type           = "gp2"
      volume_size           = "8"
      delete_on_termination = true
    },
  ]
}

variable "name" {
  default = "terraform-testing"
}

variable "vpc_subnets" {
  type    = list(string)
  default = ["subnet-038e269543d809aaa"]
}

variable "image_id" {
  default = ""
}

variable "region" {
  default = "us-west-2"
}


module "test-asg" {
  source = "../"

  lc_name  = "${var.name}-lc"
  name     = var.name
  asg_name = "${var.name}-asg"

  health_check_type = "EC2"

  vpc_zone_identifier = var.vpc_subnets

  instance_type = "t2.micro"

  image_id = var.image_id

  min_size         = 1
  max_size         = 1
  desired_capacity = 1

  ebs_block_device  = var.ebs_block_device
  root_block_device = var.root_block_device

  tags = [
    {
      key                 = "Name"
      value               = var.name
      propagate_at_launch = true
    },
    {
      key                 = "asg_name"
      value               = "${var.name}-asg"
      propagate_at_launch = true
    }
  ]
}





# module "test-asg-with_initial_lifecycle_hook" {
#   source = "../"
#   create_lc                 = false
#   lc_name                   = "${var.name}-lc"
#   name                      = var.name
#   asg_name                  = "${var.name}-asg"

#   health_check_type         = 

#   security_groups           = 
#   vpc_zone_identifier       = var.asg_subnets

#   instance_type             = "t2.micro"

#   image_id                  = var.asg_image_id

#   min_size                  = 1
#   max_size                  = 1
#   desired_capacity          = 1
#   wait_for_capacity_timeout = var.asg_wait_for_capacity_timeout

#   ebs_block_device          = var.asg_ebs_block_device
#   root_block_device         = var.asg_root_block_device

#   user_data                 = ""
#   tags                      = var.asg_tags

# }
