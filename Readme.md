# Demo Dependencies Package Repository

The repo contains the Carvel Package Repository to support demos requiring a log shipping target and a data protection target.

## Pepare manifests

```bash
# Generate EK package imagelock file
kbld -f ek-package/config/ --imgpkg-lock-output ek-package/.imgpkg/images.yaml

# Generate package file from from template
ytt -f ek-package/package-template.yaml  --data-value-file openapi=<(ytt -f ek-package/config/values-schema.yaml --data-values-schema-inspect -o openapi-v3) -v version="1.0.0" > package-repo/packages/ek.external.demo-dependencies.learn/1.0.0.yaml

# Package Repo imagelock file
kbld -f package-repo/packages/ --imgpkg-lock-output package-repo/.imgpkg/images.yaml
```

## Apply Package Repository

```bash
kubectl apply -f package-repo/package-repository.yaml
```
