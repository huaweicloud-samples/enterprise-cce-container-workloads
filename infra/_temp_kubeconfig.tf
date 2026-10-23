data "huaweicloud_cce_cluster_certificate" "std" {
  cluster_id = huaweicloud_cce_cluster.standard.id
  duration   = 1440
}

output "kubeconfig_std" {
  value     = data.huaweicloud_cce_cluster_certificate.std.kube_config_raw
  sensitive = true
}
