# создаем роль для EKS кластера

resource "aws_iam_role" "eks_cluster" {
  name = "${var.project_name}"
  tags = {
    tag-key = "${var.project_name}"
  }

  assume_role_policy = <<POLICY
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Principal": {
                "Service": [
                    "eks.amazonaws.com"
                ]
            },
            "Action": "sts:AssumeRole"
        }
    ]
}
POLICY
}

# аттачим managed policy к роли 

resource "aws_iam_role_policy_attachment" "eks_cluster_policy" {
  role       = aws_iam_role.eks_cluster.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
}

# создаем минимальный EKS кластер

resource "aws_eks_cluster" "eks_cluster" {
  name     = "${var.project_name}"
  role_arn = aws_iam_role.eks_cluster.arn

  vpc_config {
    subnet_ids = [
      aws_subnet.private-a.id,
      aws_subnet.private-b.id,
      aws_subnet.public-a.id,
      aws_subnet.public-b.id
    ]
  }

  depends_on = [aws_iam_role_policy_attachment.eks_cluster_policy] # явно указываем зависимость от полиси
}