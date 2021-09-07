provider "aws" {
  region = "eu-central-1"
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

resource "aws_security_group" "instance" {
    name = "vivien-SingleWS-aws1"

    ingress {
      cidr_blocks = [ "0.0.0.0/0" ]
      from_port = 22
      protocol = "tcp"
      to_port = 22
    }
}

resource "aws_volume_attachment" "ebs_att" {
  device_name = "/dev/sdh"
  volume_id   = aws_ebs_volume.example.id
  instance_id = aws_instance.ubuntu.id
}

resource "aws_instance" "ubuntu" {
  ami               = data.aws_ami.ubuntu.id
  availability_zone = "eu-central-1a"
  instance_type     = "t2.micro"
  key_name = "vivien"
  vpc_security_group_ids = [ aws_security_group.instance.id ]

  tags = {
    Name = "vivien-ebs-attach"
  }
}

resource "aws_ebs_volume" "example" {
  availability_zone = "eu-central-1a"
  size              = 2
}
