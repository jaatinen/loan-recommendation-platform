# Create an ECR repository for Docker image
resource "aws_ecr_repository" "loan_api_repo" {
  name                 = "loan-api"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}

# Create a VPC using official Terraform AWS VPC module
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.1.2"

  name = "loan-api-vpc"
  cidr = "10.0.0.0/16"

  azs             = ["eu-north-1a", "eu-north-1b", "eu-north-1c"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]

  enable_nat_gateway = true
  single_nat_gateway = true

  tags = {
    Environment = "dev"
    Project     = "loan-recommendation-platform"
  }
}

# Create an EKS cluster using official Terraform AWS EKS module
module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "19.21.0"

  cluster_name    = "loan-api-eks"
  cluster_version = "1.29"
  subnet_ids      = module.vpc.private_subnets
  vpc_id          = module.vpc.vpc_id

  enable_irsa                    = true
  cluster_endpoint_public_access = true
  manage_aws_auth_configmap      = true

  aws_auth_users = [
    {
      userarn  = "arn:aws:iam::562239681881:user/terraform-user"
      username = "terraform-user"
      groups   = ["system:masters"]
    },
    {
      userarn  = "arn:aws:iam::562239681881:user/github-actions-user"
      username = "github-actions-user"
      groups   = ["system:masters"]
    }
  ]

  eks_managed_node_groups = {
    default = {
      desired_capacity = 1
      max_capacity     = 2
      min_capacity     = 1

      instance_types = ["t3.small"]
    }
  }

  tags = {
    Environment = "dev"
    Project     = "loan-recommendation-platform"
  }
}