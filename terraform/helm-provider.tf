# Helm provider를 인증하기 위해 데이터 리소스 사용
data "aws_eks_cluster" "eks" {
  name = aws_eks_cluster.eks.name
}

data "aws_eks_cluster_auth" "eks" {
  name = aws_eks_cluster.eks.name
}

# Helm provider 설정
provider "helm" {
  kubernetes = {
    host                   = data.aws_eks_cluster.eks.endpoint
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.eks.certificate_authority[0].data)
    token                  = data.aws_eks_cluster_auth.eks.token
  }
}

# config_path를 사용하여 kubeconfig 파일로 접근
# [중요!!] terraform 명령어를 실행하는 환경에서 ~/.kube/config 경로의 kubeconfig 파일이 정상적으로 Kubernetes Cluster에 접근할 수 있어야 한다.
/*
provider "helm" {
  kubernetes = {
    config_path = "~/.kube/config"
  }
}
*/
