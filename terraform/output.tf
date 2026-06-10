output "cluster_endpoint" {
  description = "EKS cluster endpoint"
  value       = aws_eks_cluster.main.endpoint
  sensitive   = false
}

output "cluster_security_group_id" {
  description = "Security group ID attached to EKS cluster"
  value       = aws_eks_cluster.main.vpc_config[0].cluster_security_group_id
}

output "rds_endpoint" {
  description = "RDS MySQL endpoint"
  value       = aws_db_instance.mysql.endpoint
  sensitive   = true
}

output "rds_password_secret_arn" {
  description = "ARN of RDS password secret"
  value       = aws_secretsmanager_secret.db_password.arn
}

output "configure_kubectl" {
  description = "Command to configure kubectl"
  value       = "aws eks update-kubeconfig --region ${var.aws_region} --name ${var.cluster_name}"
}

output "node_roles" {
  description = "Node group roles for scheduling"
  value = {
    frontend = aws_eks_node_group.frontend.labels
    backend  = aws_eks_node_group.backend.labels
    redis    = aws_eks_node_group.redis.labels
  }
}