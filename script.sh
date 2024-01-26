flux bootstrap github \
  --owner=$GITHUB_USER \
  --repository=mssandbox-gitops \
  --branch=main \
  --path=./root \
  --personal

flux create source git mssandbox \
  --url=https://github.com/RobertPolanski/mssandbox-gitops \
  --branch=main \
  --interval=30s \
  --export > ./root/mssandbox-source.yaml

flux create kustomization mssandbox \
  --target-namespace=mssandbox \
  --source=mssandbox \
  --path="./app" \
  --prune=true \
  --interval=1m \
  --export > ./root/mssandbox-kustomization.yaml


helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo add stable https://charts.helm.sh/stable
helm repo update

helm install --namespace monitoring prometheus prometheus-community/prometheus --set nodeExporter.hostRootfs=false
helm delete prometheus -n monitoring

kubectl expose service prometheus-server --type=NodePort --target-port=9090 --name=prometheus-server-ext -n monitoring

helm repo add grafana https://grafana.github.io/helm-charts

helm repo update

helm install grafana bitnami/grafana -n monitoring


