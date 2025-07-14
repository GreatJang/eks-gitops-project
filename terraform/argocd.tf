# argocd.tf
## Helm Provider를 사용하여 Argo CD를 EKS 클러스터에 설치하는 코드

resource "helm_release" "argocd" {
  name             = "argocd"
  repository       = "https://argoproj.github.io/argo-helm"
  chart            = "argo-cd"
  namespace        = "argocd"
  create_namespace = true
  version          = "6.7.15" # 2025-07-14 기준 최신 버전, 버전 고정을 권장

  # Argo CD UI 접속을 위해 서비스 타입을 LoadBalancer로 설정
  set = [
    {
      name  = "server.service.type"
      value = "LoadBalancer"
      type  = "string"
    }
  ]

  # EKS 클러스터가 완전히 생성된 후에 Helm 차트가 설치되도록 의존성 명시
  depends_on = [
    aws_eks_cluster.eks_cluster,
    aws_eks_node_group.eks_nodes
  ]
}