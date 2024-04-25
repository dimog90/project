# создаем роль для eks worker


resource "aws_iam_role" "nodes" {
  name = "${var.project_name}-nodes-role"


  assume_role_policy = jsonencode({
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
    }]
    Version = "2012-10-17"
  })
}

# аттачим managed policy к созданной роли

resource "aws_iam_role_policy_attachment" "worker_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.nodes.name
}

resource "aws_iam_role_policy_attachment" "cni_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.nodes.name
}

resource "aws_iam_role_policy_attachment" "ecr_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.nodes.name
}


# создаем aws node group
resource "aws_eks_node_group" "nodegroup" {
  cluster_name    = aws_eks_cluster.eks_cluster.name 
  node_group_name = "${var.project_name}-nodegroup"
  node_role_arn   = aws_iam_role.nodes.arn 


  subnet_ids = [
    aws_subnet.private-a.id,
    aws_subnet.private-b.id
  ]

  capacity_type  = "ON_DEMAND" 
  instance_types = ["t2.micro"] 


  scaling_config {
    desired_size = 2
    max_size     = 2
    min_size     = 2
  }


  update_config {
    max_unavailable = 1
  }


  labels = {
    node = "kubenode"
  }

 
  depends_on = [
    aws_iam_role_policy_attachment.worker_policy,
    aws_iam_role_policy_attachment.cni_policy,
    aws_iam_role_policy_attachment.ecr_policy,
  ]
}