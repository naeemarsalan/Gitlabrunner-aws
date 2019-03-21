variable "aws_region" {
  default = ""
}

variable "aws_keyname" {
  default = ""
}

variable "instance_type" {
  default = "t2.micro"
}

variable "hostname" {
  default = "Gitlab-Runner-Scaled"
}

# Tags
variable "tag_name" {
  default = "gitlab-runner"
}

variable "tag_project" {
  default = "gitlab-runner"
}

variable "tag_owner" {
  default = "DevOps"
}

variable "tag_stage" {
  default = "Dev"
}


variable "gitlab_runner_name" {
  description = "The name of the gitlab runner to identify in the UI"
  default = "Gitlab Runner Scaled"
}

variable "gitlab_runner_registration_token" {
  description = "The intial project registration token"
  default = "${GIT_TOKEN}"
}

variable "aws_id" {
  default = "${AWS_ACCESS_KEY_ID}"
}
variable "aws_key" {
  default = "${AWS_SECRET_ACCESS_KEY}"
}

var "bucket_name" {
  default = ""
}

var "bucket_folder" {
  default = ""
}


var "subnetid" {
  default = ""
}

var "vpc_id" {
  default = ""
}

var "gitlaburl" {
  default = ""
}

var "sec_group" {
  default = ""
}


# Collection of tags to use for each resource
locals {
  tags = {
    Terraform = true
    Project = "${var.tag_project}"
    Stage = "${var.tag_stage}"
    Owner = "${var.tag_owner}"
  }
}

