module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 4.0"

  name = "poc-vpc"
  cidr = "10.0.0.0/16"
  azs  = slice(data.aws_availability_zones.available.names,0,2)
  public_subnets  = ["10.0.1.0/24","10.0.2.0/24"]
  private_subnets = ["10.0.3.0/24","10.0.4.0/24"]
}

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.0"

  cluster_name    = var.cluster_name
  cluster_version = "1.30"

  subnets = module.vpc.private_subnets
  vpc_id  = module.vpc.vpc_id

  node_groups = {
    default = {
      desired_capacity = var.desired_capacity
      instance_types   = [var.node_instance_type]
    }
  }
}
