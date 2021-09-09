provider "aws" {
  region = "us-west-2"
}

data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-bionic-*-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }
}


resource "aws_instance" "ubuntu" {
  ami               = data.aws_ami.ubuntu.id
  availability_zone = "us-west-2a"
  instance_type     = "t2.micro"

  tags = {
    Name = "vivien-ebs-attach"
  }
}

variable "EBS_VOLUMES" {
  default = {
    "/dev/sdh" = {
      size        = 15
      type        = "gp3"
      snapshot_id = null
    },
    "/dev/sdi" = {
      size        = 19
      type        = "gp3"
      snapshot_id = null
    }
  }

}

output "EBS_VOLUMES_var" {
  value = var.EBS_VOLUMES
}

resource "aws_ebs_volume" "example" {
  for_each          = var.EBS_VOLUMES
  availability_zone = "us-west-2a"
  size              = each.value.size

  tags = {
    Name = "HelloWorld"
  }
}

output "EBS_VOLUMES_res" {
  value = aws_ebs_volume.example
}


resource "aws_volume_attachment" "ebs_att" {
  for_each    = aws_ebs_volume.example
  device_name = each.key
  volume_id   = each.value.id
  instance_id = aws_instance.ubuntu.id
}
