# Demo Dependencies Package Repository

The repo contains the Carvel Package Repository to support demos requiring a log shipping target and a data protection target.

## Pepare manifests

```bash
# Generate EK package imagelock file
kbld -f packages/ek/1.0.0/bundle/config --imgpkg-lock-output packages/ek/1.0.0/bundle/.imgpkg/images.yml

# Generate package file from from template
ytt -f packages/ek/1.0.0/package-template.yaml  --data-value-file openapi=<(ytt -f packages/ek/1.0.0/bundle/config/values-schema.yaml --data-values-schema-inspect -o openapi-v3) -v version="1.0.0" > package-repo/packages/ek.external.demo-dependencies.learn/1.0.0.yaml

# Copy over metada file
cp packages/ek/metadata.yaml package-repo/packages/ek.external.demo-dependencies.learn/


# Package Repo imagelock file
kbld -f package-repo/packages/ --imgpkg-lock-output package-repo/.imgpkg/images.yaml
```

## Work with package repository

```bash
kubectl apply -f package-repo/package-repository.yaml

tanzu package repository list
tanzu package available list
tanzu package available get ek.external.demo-dependencies.learn/1.0.0
tanzu package available get ek.external.demo-dependencies.learn/1.0.0 --values-schema

cat > /tmp/values.yaml << EOF
elasticsearch:
  ingress:
    virtual_host_fqdn: "elasticsearch.foo.org"
kibana:
  ingress:
    virtual_host_fqdn: "logs.foo.org"
EOF

tanzu package install elasticsearch-kibana \
    --package-name ek.external.demo-dependencies.learn \
    --version 1.0.0 \
    --values-file /tmp/values.yaml
```
