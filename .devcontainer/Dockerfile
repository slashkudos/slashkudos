# See here for image contents: https://github.com/microsoft/vscode-dev-containers/tree/v0.203.0/containers/debian/.devcontainer/base.Dockerfile

# [Choice] Debian version (use bullseye or stretch on local arm64/Apple Silicon): bullseye, buster, stretch
ARG VARIANT="buster"
FROM mcr.microsoft.com/vscode/devcontainers/base:0-${VARIANT}

RUN echo "Installing node" \
    && apt-get update && export DEBIAN_FRONTEND=noninteractive \
    && curl -fsSL https://deb.nodesource.com/setup_17.x | bash - \
    && apt-get install -y --no-install-recommends nodejs

RUN echo "Installing aws cli" \
    && curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" \
    && unzip awscliv2.zip \
    && sudo ./aws/install

RUN echo "Installng Ruby and RVM" \
    && gpg --keyserver keys.openpgp.org --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 7D2BAF1CF37B13E2069D6956105BD0E739499BDB \
    && curl -sSL https://get.rvm.io | bash -s stable --ruby

RUN echo "Installing rubygems" \
    && apt-get update && export DEBIAN_FRONTEND=noninteractive \
    && apt-get install -y --no-install-recommends rubygems

# Keep this version in sync with ubuntu-latest
# https://github.com/actions/virtual-environments/blob/main/images/linux/Ubuntu2004-Readme.md#java
RUN echo "Installing Java" \
    && apt-get update && export DEBIAN_FRONTEND=noninteractive \
    && apt-get install -y --no-install-recommends openjdk-11-jdk
