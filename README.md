# 🚀Steps to Deploy Scripts

This guide documents the steps I used to set up a Kubernetes local cluster, configure networking, deploy applications, manage secrets securely, and set up observability using Prometheus.

---

## 🔧 Prerequisites

- Docker
- [kind](https://kind.sigs.k8s.io/) (Kubernetes in Docker)
- `kubectl` configured to point to your kind cluster
- [Helm](https://helm.sh/)
- `kubeseal` CLI for sealing secrets

-- Build docler image: `docker buildx build -t account/repo ./app/`

---

## 📥 1. Install NGINX Ingress Controller

Deploy the NGINX ingress controller using Helm:

```bash
helm upgrade --install ingress-nginx ingress-nginx \
  --repo https://kubernetes.github.io/ingress-nginx \
  --namespace ingress-nginx --create-namespace
```

Alternatively, deploy manually using a static manifest:

```bash
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.12.3/deploy/static/provider/cloud/deploy.yaml
```

---

## 📦 2. Load Docker Image into kind Cluster

Load your locally built Docker image into the kind cluster:

```bash
kind load docker-image pman06/production-deployment:v1
```

This ensures the cluster nodes can access the app image even if it's not pushed to a registry.

---

## 🔐 3. Install Sealed Secrets Controller

Sealed Secrets provides a secure way to store Kubernetes secrets in version control.

```bash
kubectl apply -f https://github.com/bitnami-labs/sealed-secrets/releases/download/v0.30.0/controller.yaml
```

### Seal Your Secrets:

```bash
kubeseal --fetch-cert > clustercert.crt
kubeseal --cert clustercert.crt < secrets.yaml > k8s/sealedsecret.yaml
```

The `sealedsecret.yaml` can now be safely committed to source control.

---

## 🌐 4. Configure Network Policy (Calico)

Install Calico as a network policy provider:

```bash
kubectl apply -f https://raw.githubusercontent.com/projectcalico/calico/v3.30.2/manifests/calico.yaml
```

This enables enforcement of Kubernetes `NetworkPolicy` resources.

---

## 📊 5. Install Prometheus for Observability

You can deploy Prometheus using the Prometheus Operator bundle:

```bash
kubectl apply -f https://raw.githubusercontent.com/prometheus-operator/prometheus-operator/main/bundle.yaml
```

Or with Helm (recommended):

```bash
helm install kube-prometheus-stack prometheus-community/kube-prometheus-stack \
  --namespace monitoring --create-namespace
```

This includes Prometheus, Alertmanager, and Grafana in one stack.

---

## 🗄️ 6. Prepare Persistent Volume for PostgreSQL

Ensure proper data directory setup on worker node:

```bash
mkdir -p /mnt/data/postgres
chown 10999:10999 /mnt/data -R
chmod +x /mnt/data -R
```

This sets permissions for your PostgreSQL pod to use this path as a volume mount.

---

## 🔑 7. Create Unsealed Secret for PostgreSQL Connection

You can create a Kubernetes secret like this:

```bash
kubectl create secret generic db-cres \
  --from-literal=DATABASE_URL=postgresql://postgres:postgres@my-db:5432/item \
  -o yaml --dry-run=client
```

Use `kubeseal` to generate a sealed version to include in your deployments.

---

## ✅ Next Steps

- Deploy app and database using `kubectl apply -f ./k8s -R`
- Deploy prometheus, alertmanager and grafana and database using `kubectl apply -f ./monitoring -R`
- Expose services with Ingress resources
- Use Grafana dashboards to monitor app and database metrics

---
