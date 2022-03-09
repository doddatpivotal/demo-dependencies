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

WORKING_FOLDER=packages/minio/1.0.0/bundle
SERVICE_FOLDER=minio

mv ${WORKING_FOLDER}/chart/values.yaml ${WORKING_FOLDER}/chart/values.yaml.original
echo -e "#@data/values\n---\n\n" > ${WORKING_FOLDER}/chart/values.yaml
ytt -f ${WORKING_FOLDER}/chart/values.yaml.original --file-mark "values.yaml.original:type=yaml-plain" -f ${WORKING_FOLDER}/../helm/values-overlay.yaml >> ${WORKING_FOLDER}/chart/values.yaml

CHART_VERSION=$(yq eval .version ${WORKING_FOLDER}/chart/Chart.yaml)
APP_VERSION=$(yq eval .appVersion ${WORKING_FOLDER}/chart/Chart.yaml)

# Add chart version to the end of the values file.
yq eval '{"chartInfo": { "appVersion": .appVersion } } ' ${WORKING_FOLDER}/chart/Chart.yaml >> ${WORKING_FOLDER}/chart/values.yaml

echo -e "#! I am a sample that was automatically generated with ${BUILD_SCRIPT}\n\n---" > packages/minio/1.0.0/sample/${SERVICE_FOLDER}-${CHART_VERSION}.yaml
helm template ${PACKAGE} ${WORKING_FOLDER}/chart --namespace sample-namespace --include-crds \
| ytt --ignore-unknown-comments -f ${WORKING_FOLDER}/chart/values.yaml -f - -f ${WORKING_FOLDER}/config \
| kbld -f - --imgpkg-lock-output ${WORKING_FOLDER}/.imgpkg/images.yml >> packages/minio/1.0.0/sample/${SERVICE_FOLDER}-${CHART_VERSION}.yaml

# Generate package file from from template
ytt -f packages/minio/1.0.0/package-template.yaml \
    --data-value-file openapi=<(ytt -f packages/minio/1.0.0/bundle/config/values-schema.yaml --data-values-schema-inspect -o openapi-v3) \
    -v version="1.0.0" > package-repo/packages/minio.external.demo-dependencies.learn/1.0.0.yaml
# Copy over metada file
cp packages/minio/metadata.yaml package-repo/packages/minio.external.demo-dependencies.learn/

# Package Repo imagelock file
kbld -f package-repo/packages/ --imgpkg-lock-output package-repo/.imgpkg/images.yaml
