data "terraform_remote_state" "s3" {
  backend = "s3"

  config {
    encrypt = "true"
    bucket  = "${var.bucket_name}"
    key     = "${var.bucket_folder}"
    region  = "${var.aws_region}"
    dynamodb_table = "terraform-state-lock-dynamo"
  }
}

data "aws_ami" "gitlab-runner" {
  most_recent = true

  filter {
    name   = "name"
    values = ["gitlab_runner-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["${var.ami_owner}"]
}

resource "aws_instance" "gitlab-runner" {
  ami           		= "${data.aws_ami.gitlab-runner.id}"
  instance_type 		= "${var.instance_type}"
  key_name 			= "${var.aws_keyname}"
  associate_public_ip_address 	= "false"
  subnet_id 			= "${var.subnetid}"
  vpc_security_group_ids 	= ["${var.vpc_id}"]
  tags      			= "${merge(local.tags, map("Name", "${var.tag_name}"))}"
  user_data       		= <<EOF
#!/bin/bash
export RUNNER_TAG_LIST="docker, dind"
export RUNNER_NAME=${var.gitlab_runner_name}
export REGISTRATION_TOKEN=${var.gitlab_runner_registration_token}
export AWS_KEY_ID=${var.aws_id}
export AWS_SECRET_KEY=${var.aws_key}
export GitlabURL=${var.gitlaburl}
export vpc_id=${var.vpc_id}
export subnet_id=${var.subnetid}
export sec_group=${var.sec_group}
export REGION=${var.aws_region}
/opt/runner-init.sh
EOF
}

output "instance-id" {
  value = "${aws_instance.gitlab-runner.id}"
}
output "private-ip" {
  value = "${aws_instance.gitlab-runner.private_ip}"
}

