# developer 사용자 추가
resource "aws_iam_user" "developer" {
  name = "developer"
}

# 최소한의 로컬 K8s 클러스터 구성 업데이트 및 연결 권한 부여
resource "aws_iam_policy" "developer_eks" {
  name = "AmazonEKSDeveloperPolicy"

  policy = <<POLICY
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "eks:DescribeCluster",
                "eks:ListClusters"
            ],
            "Resource": "*"
        }
    ]
}
POLICY
}

resource "aws_iam_user_policy_attachment" "developer_eks" {
  user       = aws_iam_user.developer.name
  policy_arn = aws_iam_policy.developer_eks.arn
}

# EKS API를 사용하여 developer IAM User를 RBAC my-viewer 그룹에 매핑
# 이전 K8s ConfigMap 방식 대신 권장하는 방법
resource "aws_eks_access_entry" "developer" {
  cluster_name      = aws_eks_cluster.eks.name
  principal_arn     = aws_iam_user.developer.arn
  kubernetes_groups = ["my-viewer"]
}
