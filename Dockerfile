FROM microsoft/vsts-agent:ubuntu-16.04-tfs-2018-docker-17.06.0-ce-standard

## Install Packages
RUN set -x \
    && apt-get update \
    && apt-get install -y -f --no-install-recommends \
        software-properties-common \
    && apt-get clean

## Install Powershell modules
RUN set -x \
    && pwsh -c "Install-Module -Force azure" \
    && pwsh -c "Install-Module -Force powershell-yaml" \
    && pwsh -c "Install-Module -Force Posh-SSH"

## Install Golang
RUN set -x \
  && add-apt-repository ppa:gophers/archive \
  && apt-get update \
  && apt-get install -y -f --no-install-recommends golang-1.9-go \
  && apt-get clean
