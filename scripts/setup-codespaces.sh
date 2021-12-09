#!/bin/bash

unset GITHUB_TOKEN

gh auth login -h github.com
gh auth setup-git -h github.com
gh auth status -t

GITHUB_TOKEN=$(sed -n -e 's/^.*oauth_token: //p' $HOME/.config/gh/hosts.yml)
echo "GITHUB_TOKEN: $GITHUB_TOKEN"

gh repo clone slashkudos/kudos-api /workspaces/kudos-api
pwsh /workspaces/kudos-api/scripts/Update-DevContainer.ps1

gh repo clone slashkudos/kudos-site /workspaces/kudos-site
gh repo clone slashkudos/kudos-test /workspaces/kudos-test
gh repo clone slashkudos/kudos-twitter /workspaces/kudos-twitter
gh repo clone slashkudos/kudos-web /workspaces/kudos-web

