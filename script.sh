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