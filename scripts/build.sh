#!/bin/bash -e

# Handle EK Package
kbld -f packages/ek/1.0.0/bundle/config --imgpkg-lock-output packages/ek/1.0.0/bundle/.imgpkg/images.yml
# Generate package file from from template
ytt -f packages/ek/1.0.0/package-template.yaml \
    --data-value-file openapi=<(ytt -f packages/ek/1.0.0/bundle/config/values-schema.yaml --data-values-schema-inspect -o openapi-v3) \
    -v version="1.0.0" > package-repo/packages/ek.external.demo-dependencies.learn/1.0.0.yaml
# Copy over metada file
cp packages/ek/metadata.yaml package-repo/packages/ek.external.demo-dependencies.learn/

# Handle Minio Package

pushd packages/minio/1.0.0
vendir sync
popd

# mv packages/minio/1.0.0/bundle/chart/values.yaml packages/minio/1.0.0/bundle/chart/values.yaml.original
# echo -e "#@data/values\n---\n\n" > packages/minio/1.0.0/bundle/chart/values.yaml
# ytt -f packages/minio/1.0.0/bundle/chart/values.yaml.original --file-mark "values.yaml.original:type=yaml-plain" -f packages/minio/1.0.0/helm/values-overlay.yaml >> packages/minio/1.0.0/bundle/chart/values.yaml

# Generate package file from from template
ytt -f packages/minio/1.0.0/package-template.yaml \
    --data-value-file openapi=<(ytt -f packages/minio/1.0.0/bundle/config/values-schema.yaml --data-values-schema-inspect -o openapi-v3) \
    -v version="1.0.0" > package-repo/packages/minio.external.demo-dependencies.learn/1.0.0.yaml
# Copy over metada file
cp packages/minio/metadata.yaml package-repo/packages/minio.external.demo-dependencies.learn/

# Package Repo imagelock file
kbld -f package-repo/packages/ --imgpkg-lock-output package-repo/.imgpkg/images.yaml
