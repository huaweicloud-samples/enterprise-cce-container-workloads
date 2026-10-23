output "vpc_id" {
  description = "VPC ID"
  value       = huaweicloud_vpc.this.id
}

output "subnet_id" {
  description = "子网 ID"
  value       = huaweicloud_vpc_subnet.this.id
}

output "cluster_id" {
  description = "CCE 标准集群 ID"
  value       = huaweicloud_cce_cluster.standard.id
}

output "cluster_name" {
  description = "CCE 标准集群名称"
  value       = huaweicloud_cce_cluster.standard.name
}

output "kubeconfig_url" {
  description = "集群访问凭证获取地址（控制台 / API）"
  value       = "https://console.huaweicloud.com/cce2.0/?region=${var.region}#/cluster/${huaweicloud_cce_cluster.standard.id}/detail"
}

output "workload_namespace" {
  description = "工作负载命名空间"
  value       = huaweicloud_cce_namespace.default.name
}
