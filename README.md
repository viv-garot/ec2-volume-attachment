

# Description
EC2 instance (ssh access) + a 2GB ebs volume attachment

## Pre-requirements

* [Git](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git) 
* [Terraform cli](https://learn.hashicorp.com/tutorials/terraform/install-cli)
* [aws account](https://aws.amazon.com/getting-started/?nc1=h_ls)


## How to use this repo

- Clone
- Run
- Cleanup

---

### Clone the repo

```
git clone https://github.com/viv-garot/ec2-volume-attachment
```

### Change directory

```
cd ec2-volume-attachment
```

### Run

* Init:

```
terraform init
```

_sample_:

```
terraform init

Initializing the backend...

Initializing provider plugins...
- Finding latest version of hashicorp/aws...
- Installing hashicorp/aws v3.57.0...
- Installed hashicorp/aws v3.57.0 (signed by HashiCorp)

Terraform has created a lock file .terraform.lock.hcl to record the provider
selections it made above. Include this file in your version control repository
so that Terraform can guarantee to make the same selections by default when
you run "terraform init" in the future.

Terraform has been successfully initialized!

You may now begin working with Terraform. Try running "terraform plan" to see
any changes that are required for your infrastructure. All Terraform commands
should now work.

If you ever set or change modules or backend configuration for Terraform,
rerun this command to reinitialize your working directory. If you forget, other
commands will detect it and remind you to do so if necessary.
```

* Apply:

```
terraform apply
```

_sample_:

```
terraform apply

Terraform used the selected providers to generate the following execution plan. Resource actions are indicated
with the following symbols:
  + create

Terraform will perform the following actions:

  # aws_ebs_volume.example will be created
  + resource "aws_ebs_volume" "example" {
      + arn               = (known after apply)
      + availability_zone = "eu-central-1a"
      + encrypted         = (known after apply)
      + id                = (known after apply)
      + iops              = (known after apply)
      + kms_key_id        = (known after apply)
      + size              = 2
      + snapshot_id       = (known after apply)
      + tags_all          = (known after apply)
      + throughput        = (known after apply)
      + type              = (known after apply)
    }

  # aws_instance.ubuntu will be created
  + resource "aws_instance" "ubuntu" {
      + ami                                  = "ami-0f4998c0314460d14"
      + arn                                  = (known after apply)
      + associate_public_ip_address          = (known after apply)
      + availability_zone                    = "eu-central-1a"
      + cpu_core_count                       = (known after apply)
      + cpu_threads_per_core                 = (known after apply)
      + disable_api_termination              = (known after apply)
      + ebs_optimized                        = (known after apply)
      + get_password_data                    = false
      + host_id                              = (known after apply)
      + id                                   = (known after apply)
      + instance_initiated_shutdown_behavior = (known after apply)
      + instance_state                       = (known after apply)
      + instance_type                        = "t2.micro"
      
[ .... ]

Plan: 4 to add, 0 to change, 0 to destroy.

Do you want to perform these actions?
  Terraform will perform the actions described above.
  Only 'yes' will be accepted to approve.

  Enter a value: yes

aws_ebs_volume.example: Creating...
aws_security_group.instance: Creating...
aws_security_group.instance: Creation complete after 3s [id=sg-03a2b75abe1feffa4]
aws_instance.ubuntu: Creating...
aws_ebs_volume.example: Still creating... [10s elapsed]
aws_ebs_volume.example: Creation complete after 11s [id=vol-0d00164a9a0ba57cf]
aws_instance.ubuntu: Still creating... [10s elapsed]
aws_instance.ubuntu: Still creating... [20s elapsed]
aws_instance.ubuntu: Still creating... [30s elapsed]
aws_instance.ubuntu: Still creating... [40s elapsed]
aws_instance.ubuntu: Still creating... [50s elapsed]
aws_instance.ubuntu: Still creating... [1m0s elapsed]
aws_instance.ubuntu: Still creating... [1m10s elapsed]
aws_instance.ubuntu: Still creating... [1m20s elapsed]
aws_instance.ubuntu: Creation complete after 1m24s [id=i-04901cb18c83375bb]
aws_volume_attachment.ebs_att: Creating...
aws_volume_attachment.ebs_att: Still creating... [10s elapsed]
aws_volume_attachment.ebs_att: Still creating... [20s elapsed]
aws_volume_attachment.ebs_att: Still creating... [30s elapsed]
aws_volume_attachment.ebs_att: Creation complete after 37s [id=vai-3511807046]

Apply complete! Resources: 4 added, 0 changed, 0 destroyed.

Outputs:

instance_public_dns = "ec2-18-195-198-9.eu-central-1.compute.amazonaws.com"
```

* Confirm the 2G volume is attached to this instance as xvdh (for this step you need a key-pair already available in AWS EC2 + update the code line 46 _key_name               = "vivien"_ with your key name + update the command with your private key local path)

```
ssh -i ~/.ssh/vivien.cer ubuntu@$(terraform output -raw instance_public_dns) "lsblk"
```

_sample_:

```
ssh -i ~/.ssh/vivien.cer ubuntu@$(terraform output -raw instance_public_dns) "lsblk"
NAME    MAJ:MIN RM  SIZE RO TYPE MOUNTPOINT
loop0     7:0    0 32.3M  1 loop /snap/snapd/12883
loop1     7:1    0 55.4M  1 loop /snap/core18/2128
loop2     7:2    0   25M  1 loop /snap/amazon-ssm-agent/4046
xvda    202:0    0    8G  0 disk
`-xvda1 202:1    0    8G  0 part /
xvdh    202:112  0    2G  0 disk
```

### Cleanup

```
terraform destroy
```

_sample_:

```
terraform destroy
aws_ebs_volume.example: Refreshing state... [id=vol-0d00164a9a0ba57cf]
aws_security_group.instance: Refreshing state... [id=sg-03a2b75abe1feffa4]
aws_instance.ubuntu: Refreshing state... [id=i-04901cb18c83375bb]
aws_volume_attachment.ebs_att: Refreshing state... [id=vai-3511807046]

[ .... ]

Plan: 0 to add, 0 to change, 4 to destroy.

Changes to Outputs:
  - instance_public_dns = "ec2-18-195-198-9.eu-central-1.compute.amazonaws.com" -> null

Do you really want to destroy all resources?
  Terraform will destroy all your managed infrastructure, as shown above.
  There is no undo. Only 'yes' will be accepted to confirm.

  Enter a value: yes

aws_volume_attachment.ebs_att: Destroying... [id=vai-3511807046]
aws_volume_attachment.ebs_att: Still destroying... [id=vai-3511807046, 10s elapsed]
aws_volume_attachment.ebs_att: Destruction complete after 13s
aws_ebs_volume.example: Destroying... [id=vol-0d00164a9a0ba57cf]
aws_instance.ubuntu: Destroying... [id=i-04901cb18c83375bb]
aws_ebs_volume.example: Destruction complete after 1s
aws_instance.ubuntu: Still destroying... [id=i-04901cb18c83375bb, 10s elapsed]
aws_instance.ubuntu: Still destroying... [id=i-04901cb18c83375bb, 20s elapsed]
aws_instance.ubuntu: Still destroying... [id=i-04901cb18c83375bb, 30s elapsed]
aws_instance.ubuntu: Still destroying... [id=i-04901cb18c83375bb, 40s elapsed]
aws_instance.ubuntu: Still destroying... [id=i-04901cb18c83375bb, 50s elapsed]
aws_instance.ubuntu: Still destroying... [id=i-04901cb18c83375bb, 1m0s elapsed]
aws_instance.ubuntu: Destruction complete after 1m5s
aws_security_group.instance: Destroying... [id=sg-03a2b75abe1feffa4]
aws_security_group.instance: Still destroying... [id=sg-03a2b75abe1feffa4, 10s elapsed]
aws_security_group.instance: Still destroying... [id=sg-03a2b75abe1feffa4, 20s elapsed]
aws_security_group.instance: Still destroying... [id=sg-03a2b75abe1feffa4, 30s elapsed]
aws_security_group.instance: Still destroying... [id=sg-03a2b75abe1feffa4, 40s elapsed]
aws_security_group.instance: Still destroying... [id=sg-03a2b75abe1feffa4, 50s elapsed]
aws_security_group.instance: Destruction complete after 53s

Destroy complete! Resources: 4 destroyed.
```
