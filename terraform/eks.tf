resource "aws_iam_role" "eks" {
  name = "${local.env}-${local.eks_name}-eks-cluster"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "eks.amazonaws.com"
      }
    }
  ]
}
POLICY
}

# EKS에서 사용할 IAM Role에 AmazonEKSClusterPolicy 정책 연결
resource "aws_iam_role_policy_attachment" "eks" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.eks.name
}

# EKS 클러스터 생성
resource "aws_eks_cluster" "eks" {
  name     = "${local.env}-${local.eks_name}-cluster" # 동일 계정에 여러 EKS 클러스터 생성 시 이름 중복 방지
  version  = local.eks_version
  role_arn = aws_iam_role.eks.arn # EKS 클러스터에 연결할 IAM Role ARN

  # 네트워크 설정 구성
  vpc_config {
    endpoint_private_access = false # 인터넷에 노출하고 싶지 않은 개인 서비스 및 트래픽 유입 차단 가능
    endpoint_public_access  = true  # 인터넷에서 EKS API 서버에 접근 가능

    subnet_ids = [
      aws_subnet.private_zone1.id,
      aws_subnet.private_zone2.id
    ]
  }

  # 클러스터 접속을 위한 인증 설정
  # aws-auth (k8s 인증) configmap 사용 x
  access_config {
    authentication_mode                         = "API"
    bootstrap_cluster_creator_admin_permissions = true
  }

  depends_on = [aws_iam_role_policy_attachment.eks]
}
