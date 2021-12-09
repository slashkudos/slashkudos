# See here for image contents: https://github.com/microsoft/vscode-dev-containers/tree/v0.203.0/containers/debian/.devcontainer/base.Dockerfile

# [Choice] Debian version (use bullseye or stretch on local arm64/Apple Silicon): bullseye, buster, stretch
ARG VARIANT="buster"
FROM mcr.microsoft.com/vscode/devcontainers/base:0-${VARIANT}

RUN echo "Installing node"\
    && apt-get update && export DEBIAN_FRONTEND=noninteractive \
    && curl -fsSL https://deb.nodesource.com/setup_17.x | bash - \
    && apt-get install -y --no-install-recommends nodejs

RUN echo "Installing aws cli" \
    && curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" \
    && unzip awscliv2.zip \
    && sudo ./aws/install
