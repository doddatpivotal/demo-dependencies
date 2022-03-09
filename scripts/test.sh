kubectl apply -f package-repo/packages/minio.external.demo-dependencies.learn/1.0.0.yaml 
kubectl delete -f package-install.yaml
kubectl apply -f package-install.yaml