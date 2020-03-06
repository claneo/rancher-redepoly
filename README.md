# rancher-redepoly

A simple script to execute `Redeploy` command in Rancher.

Helpful in CI environment.

## Usage

### Directly

```bash
docker run --rm \
  -e ENDPOINT=YOUR_RANCHER_ENDPOINT \
  -e TOKEN=YOUR_TOKEN \
  -e CLUSTER=YOUR_CLUSTER_NAME \
  PROJECT NAMESPACE DEPLOYMENT
```

### Build your own image

Dockerfile:

```dockerfile
FROM rancher-redeploy
ENV ENDPOINT=YOUR_RANCHER_ENDPOINT
ENV TOKEN=YOUR_TOKEN
ENV CLUSTER=YOUR_CLUSTER_NAME
```

Usage:

`docker run --rm YOUR_IMAGE PROJECT NAMESPACE DEPLOYMENT`

### Gitlab CI example

```yaml
deploy:
  image: rancher-redeploy
  stage: deploy
  variables:
    ENDPOINT: YOUR_RANCHER_ENDPOINT
    TOKEN: YOUR_TOKEN
    CLUSTER: YOUR_CLUSTER_NAME
  script:
    - /redeploy.sh PROJECT NAMESPACE DEPLOYMENT
```
