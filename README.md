# Learn Terraform EC2

Provision Amazon EC2 instances in AWS using Terraform with environment-specific settings for `dev`, `uat`, and `prod`.

## What this project creates

- EC2 instances (`aws_instance.public`) based on `instance_count`
- A security group that allows SSH (`22/tcp`) from anywhere (`0.0.0.0/0`)
- Dynamic lookup of:
    - VPC by tag name (`default-vpc`)
    - Latest Amazon Linux 2023 AMI
    - Subnets in the selected VPC

## Naming convention

Resources use this format:

- EC2 name tag: `<prefix>-ec2-<env>-<index>`
- Security group: `<prefix>-sg-ec2-<env>`

Current local prefix in code: `jazeel`.

Example for `dev`:

- `jazeel-ec2-dev-1`

## Environment settings

Defined in `vars/`:

- `dev.tfvars`: `t2.micro`, `1` instance
- `uat.tfvars`: `t2.small`, `2` instances
- `prod.tfvars`: `t2.large`, `3` instances

## Prerequisites

- Terraform `>= 1.10`
- AWS credentials configured (e.g., `aws configure` or environment variables)
- Access to AWS region `ap-southeast-1`
- Existing S3 bucket for Terraform backend state

## Backend configuration

Remote state is configured in `backend.tf`:

- Bucket: `sctp-ce12-tfstate-bucket`
- Key: `ec2-example/terraform.tfstate`
- Region: `ap-southeast-1`

Update these values if you use a different bucket/path/region.

## Usage

From the project root:

```bash
terraform init
```

### Deploy `dev`

```bash
terraform plan -var-file="vars/dev.tfvars"
terraform apply -var-file="vars/dev.tfvars"
```

### Deploy `uat`

```bash
terraform plan -var-file="vars/uat.tfvars"
terraform apply -var-file="vars/uat.tfvars"
```

### Deploy `prod`

```bash
terraform plan -var-file="vars/prod.tfvars"
terraform apply -var-file="vars/prod.tfvars"
```

### Destroy resources

```bash
terraform destroy -var-file="vars/dev.tfvars"
```

Replace `dev.tfvars` with `uat.tfvars` or `prod.tfvars` as needed.

## Outputs

After apply, Terraform outputs:

- `my_vpc_id`
- `ami_id`
- `subnet_ids`

## Notes

- The VPC data source currently filters by tag `Name=default-vpc`; change this in `data.tf` if your VPC name differs.
- SSH is open to the internet (`0.0.0.0/0`). Restrict CIDR in `main.tf` for security.