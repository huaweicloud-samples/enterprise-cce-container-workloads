# ---------------------------------------------------------------------------
# 网络：VPC 与子网
# ---------------------------------------------------------------------------
resource "huaweicloud_vpc" "this" {
  name = "${var.cluster_name}-vpc"
  cidr = var.vpc_cidr
}

resource "huaweicloud_vpc_subnet" "this" {
  name       = "${var.cluster_name}-subnet"
  cidr       = var.subnet_cidr
  gateway_ip = cidrhost(var.subnet_cidr, 1)
  vpc_id     = huaweicloud_vpc.this.id
  primary_dns   = "100.125.1.250"
  secondary_dns = "100.125.1.251"
}

# ---------------------------------------------------------------------------
# 委托（访问容器镜像仓库）：
# 本示例工作负载全部使用公共镜像，无需配置访问委托即可拉取。
# 若改用私有镜像仓库私有镜像，请创建委托并在节点池中引用：
#   resource "huaweicloud_identity_agency" "cce_swr" { ... }
#   huaweicloud_cce_node_pool.default.agency_name = huaweicloud_identity_agency.cce_swr.name
# ---------------------------------------------------------------------------

# ---------------------------------------------------------------------------
# CCE 标准集群（基于节点池的托管集群，适合常驻工作负载）
# ---------------------------------------------------------------------------
resource "huaweicloud_cce_cluster" "standard" {
  name                   = var.cluster_name
  cluster_type           = "VirtualMachine"
  flavor_id              = "cce.s1.small"
  vpc_id                 = huaweicloud_vpc.this.id
  subnet_id              = huaweicloud_vpc_subnet.this.id
  container_network_type = "vpc-router"
  cluster_version        = "v1.28"
}

# ---------------------------------------------------------------------------
# CCE Autopilot 集群（免节点运维的全托管形态，按 Pod 调度）
# 工作负载 YAML 与标准集群完全复用，仅调度到此集群即可。
# 说明：Autopilot 集群创建前，需在目标区域控制台完成云容器引擎的首次
# 委托授权；账号未完成该授权时，可将 enable_autopilot_cluster 置为 false
# 跳过本资源，仅使用标准集群。
# ---------------------------------------------------------------------------
resource "huaweicloud_cce_autopilot_cluster" "serverless" {
  count = var.enable_autopilot_cluster ? 1 : 0

  name    = "${var.cluster_name}-autopilot"
  flavor  = "cce.autopilot.cluster"

  host_network {
    vpc    = huaweicloud_vpc.this.id
    subnet = huaweicloud_vpc_subnet.this.id
  }

  container_network {
    mode = "eni"
  }

  eni_network {
    subnets {
      subnet_id = huaweicloud_vpc_subnet.this.subnet_id
    }
  }
}

resource "huaweicloud_cce_node_pool" "default" {
  cluster_id         = huaweicloud_cce_cluster.standard.id
  name               = "${var.cluster_name}-nodepool"
  flavor_id          = var.node_flavor
  initial_node_count = var.node_count
  availability_zone  = var.availability_zone
  key_pair           = var.admin_key_pair
  subnet_id          = huaweicloud_vpc_subnet.this.id

  root_volume {
    size       = 40
    volumetype = "SAS"
  }

  data_volumes {
    size       = 100
    volumetype = "SAS"
  }

  os = "EulerOS 2.9"
}

# ---------------------------------------------------------------------------
# 命名空间：工作负载部署目标
# ---------------------------------------------------------------------------
resource "huaweicloud_cce_namespace" "default" {
  cluster_id = huaweicloud_cce_cluster.standard.id
  name       = var.workload_namespace
}
