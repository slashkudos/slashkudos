#!/bin/bash

export GITHUB_TOKEN=$SLASHKUDOS_PAT

# Auth will use GITHUB_TOKEN from Codespace
gh auth login -h github.com
gh auth setup-git -h github.com
gh auth status -t

# Automatically clone public repos
# GITHUB_TOKEN from Codespace cannot be used to clone private repos
gh repo clone slashkudos/kudos-api /workspaces/kudos-api
gh repo clone slashkudos/kudos-site /workspaces/kudos-site
gh repo clone slashkudos/kudos-twitter /workspaces/kudos-twitter
gh repo clone slashkudos/kudos-web /workspaces/kudos-web

# Run repo specific setup scripts
pwsh /workspaces/kudos-api/scripts/Update-DevContainer.ps1
