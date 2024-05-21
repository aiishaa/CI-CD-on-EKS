resource "aws_iam_role" "eks-cluster-role" {
  name = "eks-cluster-role"

  assume_role_policy = jsonencode({
    Statement = [{
      Effect: "Allow"
      Principal: {
        Service: "eks.amazonaws.com"
      }
      Action: "sts:AssumeRole"
    }]
    Version = "2012-10-17"
  })
}

resource "aws_iam_role_policy_attachment" "eks-cluster-AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.eks-cluster-role.name
}

resource "aws_eks_cluster" "eks-cluster" {
  name     = "myapp-eks-cluster"
  role_arn = aws_iam_role.eks-cluster-role.arn

  vpc_config {
    endpoint_private_access = true
    # endpoint_public_access = false
    subnet_ids = module.vpc.private_subnets
  }

  depends_on = [aws_iam_role_policy_attachment.eks-cluster-AmazonEKSClusterPolicy]
}

resource "aws_eks_addon" "coredns" {
  cluster_name                = aws_eks_cluster.eks-cluster.id
  addon_name                  = "coredns"
  resolve_conflicts_on_update = "PRESERVE"
}

resource "aws_eks_addon" "vpc_cni" {
  cluster_name                = aws_eks_cluster.eks-cluster.id
  addon_name                  = "vpc-cni"
  resolve_conflicts_on_update = "PRESERVE"
}

resource "aws_eks_addon" "kube_proxy" {
  cluster_name                = aws_eks_cluster.eks-cluster.id
  addon_name                  = "kube-proxy"
  resolve_conflicts_on_update = "PRESERVE"
}

data "aws_eks_cluster" "cluster" {
  name = aws_eks_cluster.eks-cluster.id
}
