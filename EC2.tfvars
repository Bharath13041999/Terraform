resource "aws_instance" "mySonarInstance" {
      ami           = "ami-0ee23bfc74a881de5"
      key_name = var.key_name
      instance_type = "t2.micro"
vpc_security_group_ids = [aws_security_group.sonar-sg-2022.id]
      tags= {
        Name = "sonar_instance"
      }
    }
 
resource "aws_security_group" "sonar-sg-2022" {
      name        = "security_sonar_group_2022"
      description = "security group for Sonar"
 
      ingress {
        from_port   = 9000
        to_port     = 9000
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
      }
 
     ingress {
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
      }
 
     # outbound from Sonar server
      egress {
        from_port   = 0
        to_port     = 65535
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
      }
 
      tags= {
        Name = "security_sonar"
      }
    }
 
# Create Elastic IP address for Sonar instance
resource "aws_eip" "mySonarInstance" {
  vpc      = true
instance = aws_instance.mySonarInstance.id
tags= {
    Name = "sonar_elastic_ip"
  }
}

#########################ECR and EKS################################################


# Create Subnets
resource "aws_subnet" "main" {
  count             = length(var.subnet_cidrs)
vpc_id = aws_vpc.main.id
  cidr_block        = var.subnet_cidrs[count.index]
  map_public_ip_on_launch = true
 
  tags = {
    Name = "eks-subnet-${count.index}"
  }
}
 
# Create an Internet Gateway
resource "aws_internet_gateway" "main" {
vpc_id = aws_vpc.main.id
 
  tags = {
    Name = "eks-internet-gateway"
  }
}
 
# Create a Route Table
resource "aws_route_table" "main" {
vpc_id = aws_vpc.main.id
 
  route {
    cidr_block = "0.0.0.0/0"
gateway_id = aws_internet_gateway.main.id
  }
 
  tags = {
    Name = "eks-route-table"
  }
}
 
# Associate Subnets with Route Table
resource "aws_route_table_association" "main" {
  count          = length(var.subnet_cidrs)
  subnet_id      = aws_subnet.main[count.index].id
route_table_id = aws_route_table.main.id
}
 
# Create ECR Repository
resource "aws_ecr_repository" "flask_app_repo" {
  name = var.ecr_repository_name
 
  tags = {
    Name = "flask-app-repo"
  }
}
 
# Deploy EKS Cluster
module "eks" {
  source          = "terraform-aws-modules/eks/aws"
  cluster_name    = var.eks_cluster_name
  cluster_version = "1.27"
 
vpc_id = aws_vpc.main.id
  subnet_ids = aws_subnet.main.*.id
 
  node_groups = {
    eks_nodes = {
      desired_capacity = var.desired_capacity
      max_capacity     = var.max_capacity
      min_capacity     = var.min_capacity
 
      instance_type = var.instance_type
    }
  }
 
  tags = {
    Environment = "Production"
  }
}
