FROM microsoft/vsts-agent:ubuntu-16.04-tfs-2018-docker-17.06.0-ce-standard

## Install Packages
RUN set -x \
    && apt-get update \
    && apt-get install -y -f --no-install-recommends \
        software-properties-common \
        jq \
        dos2unix \
        mysql-client \
        postgresql-client \
    && apt-get clean

## Install Powershell modules
RUN set -x \
    && pwsh -c "Install-Module -Force azure" \
    && pwsh -c "Install-Module -Force powershell-yaml" \
    && pwsh -c "Install-Module -Force Posh-SSH"

## Install tools
RUN set -x \
  # k8s kubectl
  && KUBECTL_VERSION=$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt) \
  && curl -L -o /usr/local/bin/kubectl "https://storage.googleapis.com/kubernetes-release/release/$KUBECTL_VERSION/bin/linux/amd64/kubectl" \
  && chmod +x /usr/local/bin/kubectl \
  # k8s helm
  && HELM_VERSION=2.7.2 \
  && mkdir -p /tmp/helm \
  && curl -L -o /tmp/helm/helm.tar.gz "https://kubernetes-helm.storage.googleapis.com/helm-v${HELM_VERSION}-linux-amd64.tar.gz" \
  && tar -zxvf /tmp/helm/helm.tar.gz -C /tmp/helm \
  && mv /tmp/helm/linux-amd64/helm /usr/local/bin/helm \
  && chmod +x /usr/local/bin/helm \
  && rm -rf /tmp/helm \
  && helm plugin install https://github.com/technosophos/helm-template
