# 容器工作负载实践 · 部署指导书

## 1. 前置条件

- 云账号，具备 CCE、VPC 创建权限
- 本地已安装 Terraform 1.5+ 与 kubectl
- 目标区域（默认 cn-north-4）

## 2. 创建集群与网络（基础设施即代码）

```bash
cd infra
terraform init
terraform validate
terraform apply
```

执行完成后记录输出的集群 ID 与命名空间名称，并获取集群访问凭证（kubeconfig）。

## 3. 部署工作负载

将 kubeconfig 配置到本地后，应用工作负载定义：

```bash
kubectl apply -f src/workloads/nginx-deployment.yaml
kubectl apply -f src/workloads/tomcat-deployment.yaml
kubectl apply -f src/workloads/jetty-deployment.yaml
kubectl apply -f src/workloads/wildfly-deployment.yaml
```

> 所有工作负载默认部署到 `app-workloads` 命名空间（由 Terraform 创建）。

## 4. 验证

```bash
kubectl get pods -n app-workloads
kubectl get svc -n app-workloads
```

确认各 Pod 处于 Running 状态。

## 5. 清理

```bash
kubectl delete -f src/workloads/
cd infra && terraform destroy
```

## 6. 调度形态切换

如需以无节点调度形态运行，将工作负载部署到 Serverless 容器集群即可（无需修改定义内容）：

1. 获取 Serverless 容器集群的 kubeconfig；
2. 使用相同命令 `kubectl apply -f src/workloads/*.yaml`。
