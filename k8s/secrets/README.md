# Kubernetes Secrets Directory

⚠️ **SECURITY WARNING** ⚠️

**NEVER commit actual secrets to version control!**

## Files in this directory:

- `secrets.yaml.example` - Template file (safe to commit)
- `secrets.yaml` - Your actual secrets (NEVER commit - gitignored)
- `secrets-local.yaml` - Alternative local secrets (NEVER commit - gitignored)
- `*.enc.yaml` - SOPS encrypted secrets (safe to commit)

---

## Creating Secrets

### Option 1: Manual (Development/Testing)

```bash
# Copy the template
cp secrets.yaml.example secrets.yaml

# Generate random passwords
openssl rand -base64 32

# Edit secrets.yaml with your passwords
vim secrets.yaml

# Apply to cluster
kubectl apply -f secrets.yaml
```

### Option 2: SOPS Encryption (Recommended for Production)

```bash
# Install SOPS
# macOS: brew install sops
# NixOS: Already in environment.systemPackages

# Create/edit secrets
cp secrets.yaml.example secrets.yaml
vim secrets.yaml

# Encrypt with SOPS
sops -e secrets.yaml > secrets.enc.yaml

# Commit encrypted version
git add secrets.enc.yaml
git commit -m "Add encrypted Kubernetes secrets"

# Deploy (decrypt and apply)
sops -d secrets.enc.yaml | kubectl apply -f -
```

### Option 3: Generate Script

```bash
# Use the provided script
../../scripts/generate-k8s-secrets.sh
```

---

## Security Best Practices

1. ✅ **Use Strong Passwords**
   ```bash
   # Generate 32-character password
   openssl rand -base64 32
   ```

2. ✅ **Encrypt Secrets**
   - Use SOPS for GitOps workflows
   - Use Sealed Secrets for Kubernetes-native encryption
   - Use external secret managers (Vault, AWS Secrets Manager, etc.)

3. ✅ **Rotate Regularly**
   - Change passwords every 90 days
   - Update encryption keys annually

4. ✅ **Limit Access**
   - Use Kubernetes RBAC
   - Restrict who can read secrets

5. ✅ **Audit**
   - Monitor secret access
   - Log secret modifications

---

## What's Gitignored

The following files are automatically excluded from git:

```
k8s/secrets/secrets.yaml
k8s/secrets/secrets-local.yaml
```

The following files are SAFE to commit:

```
k8s/secrets/secrets.yaml.example  ← Template only
k8s/secrets/*.enc.yaml            ← SOPS encrypted
k8s/secrets/README.md             ← This file
```

---

## Troubleshooting

### "Secret already exists"
```bash
# Delete and recreate
kubectl delete secret monitoring-secrets -n monitoring
kubectl apply -f secrets.yaml
```

### "Invalid secret format"
```bash
# Validate YAML syntax
kubectl apply --dry-run=client -f secrets.yaml
```

### "SOPS not found"
```bash
# Install SOPS
brew install sops  # macOS
nix-env -iA nixpkgs.sops  # NixOS
```

---

## Additional Resources

- [Kubernetes Secrets Documentation](https://kubernetes.io/docs/concepts/configuration/secret/)
- [SOPS Documentation](https://github.com/mozilla/sops)
- [Sealed Secrets](https://github.com/bitnami-labs/sealed-secrets)
- [External Secrets Operator](https://external-secrets.io/)
