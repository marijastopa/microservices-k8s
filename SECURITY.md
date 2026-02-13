# Security Scanning Report

## IaC Scanning - Trivy

**Scan Date:** 2026-02-13  
**Tool:** Trivy v0.x  
**Scope:** Kubernetes manifests (deployments, services, HPA, network policies)

### Summary
- **Total files scanned:** 27
- **Critical:** 0
- **High:** 10
- **Clean files:** 17 (HPA, Services, Network Policies, Ingress)

### Findings

#### KSV-0014: ReadOnlyRootFilesystem (HIGH)
**Affected:** All 10 deployments  
**Recommendation:** Set `securityContext.readOnlyRootFilesystem: true`

**Decision:** ACCEPTED for demo deployment  
**Rationale:**
- Applications may require write access to /tmp or logs
- Production would use emptyDir volumes for writable paths
- Risk mitigated by: runAsNonRoot, minimal base images, network policies