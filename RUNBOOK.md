# 🛠️ Kubernetes Operations Runbook

A concise reference for managing, debugging, and operating Kubernetes-based workloads.

---

## 🔹 1. Check Pod Health

**Purpose:** Verify the health and status of application or database pods.

### 🔧 Commands

```sh
kubectl get pods -n <namespace>
kubectl describe pod <pod-name> -n <namespace>
kubectl logs <pod-name> -n <namespace> --tail=100
```

### ✅ Tips

- Use `kubectl top pods` if metrics-server is installed.
- Look for **CrashLoopBackOff**, probe failures, or OOMKilled events.

---

## 🔹 2. Restart a Deployment

**Purpose:** Manually trigger a rolling restart to apply changes or fix issues.

### 🔧 Command

```sh
kubectl rollout restart deployment <deployment-name> -n <namespace>
```

### ✅ Expected Outcome

- New pods with updated config/image are launched.
- Old pods are terminated gracefully.

---

## 🔹 3. Rollback a Deployment

**Purpose:** Revert to the last successful deployment version.

### 🔧 Commands

```sh
kubectl rollout undo deployment <deployment-name> -n <namespace>
kubectl rollout status deployment <deployment-name> -n <namespace>
```

### ✅ Use Case

- When a new deployment causes failures or instability.

---

## 🔹 4. Scale a Deployment

**Purpose:** Adjust the number of running pods manually.

### 🔧 Command

```sh
kubectl scale deployment <deployment-name> --replicas=3 -n <namespace>
```

### ✅ Notes

- Temporarily overrides Horizontal Pod Autoscaler (HPA).
- Useful for traffic surges or cost optimization.

---

## 🔹 5. Access a Pod Shell

**Purpose:** Debug inside a running container.

### 🔧 Command

```sh
kubectl exec -it <pod-name> -n <namespace> -- /bin/sh
# or /bin/bash depending on the base image
```

### ✅ Use Case

- Run tests, check logs or environment variables, edit config.

---

## 🔹 6. Check Service and Network Connectivity

**Purpose:** Validate that services and endpoints are exposed and accessible.

### 🔧 Commands

```sh
kubectl get svc -n <namespace>
kubectl describe svc <service-name> -n <namespace>
kubectl get endpoints -n <namespace>
```

### ✅ Advanced: DNS & Connectivity Testing

```sh
kubectl run -it netshoot --image=nicolaka/netshoot --rm -- bash
# Use tools: curl, ping, dig, nslookup, etc.
```

---

## 🔹 7. Inspect Events and Failures

**Purpose:** Diagnose failures like mount issues, scheduling errors, or access problems.

### 🔧 Command

```sh
kubectl get events -n <namespace> --sort-by=.metadata.creationTimestamp
```

### ✅ Common Issues

- `FailedScheduling` – resource limits, node affinity
- `FailedMount` – volume claim or permission problems
- `BackOff` – persistent retry loops in pods

---

📘 **TIP:** Store this runbook in your Git repository as `runbook.md`  
💬 **Suggestion:** Pair each task with monitoring or alert rules for fast incident response.
