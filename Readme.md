# Demo Dependencies Package Repository

The repo contains the Carvel Package Repository to support demos requiring a log shipping target and a data protection target.

## Build Package Repostory

The following script will process the package contents and generate files for the package repository.

```bash
./scripts/build.sh
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

cat > /tmp/minio-values.yaml << EOF
EOF

tanzu package install minio \
    --package-name minio.external.demo-dependencies.learn \
    --version 1.0.0 \
    --values-file /tmp/minio-values.yaml

```

## Source and Inspiration

Thank you to [https://github.com/voor/gitlab-runner-helm-imgpkg](https://github.com/voor/gitlab-runner-helm-imgpkg) for guidance.
