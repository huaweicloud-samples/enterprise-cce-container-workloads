variable "region" {
  description = "部署区域"
  type        = string
  default     = "cn-north-4"
}

variable "cluster_name" {
  description = "CCE 集群名称"
  type        = string
  default     = "cce-container-workloads"
}

variable "vpc_cidr" {
  description = "VPC CIDR"
  type        = string
  default     = "192.168.0.0/16"
}

variable "subnet_cidr" {
  description = "子网 CIDR"
  type        = string
  default     = "192.168.0.0/24"
}

variable "availability_zone" {
  description = "可用区"
  type        = string
  default     = "cn-north-4a"
}

variable "node_flavor" {
  description = "节点规格（弹性云服务器规格）"
  type        = string
  default     = "s6.large.2"
}

variable "node_count" {
  description = "节点池初始节点数"
  type        = number
  default     = 1
}

variable "admin_key_pair" {
  description = "登录节点用的密钥对名称"
  type        = string
  default     = "cce-workloads-keypair"
}

variable "image_agency_name" {
  description = "集群用于访问容器镜像仓库的委托名称"
  type        = string
  default     = "cce-swr-access"
}

variable "workload_namespace" {
  description = "工作负载所属命名空间"
  type        = string
  default     = "app-workloads"
}

variable "enable_autopilot_cluster" {
  description = "是否创建 Autopilot 全托管集群（账号未完成目标区域控制台委托授权时置为 false）"
  type        = bool
  default     = true
}
