#!/usr/bin/env pwsh

<#
    .SYNOPSIS
    Clones all the repos, runs their setup scripts and sets up gh cli and other dev tools.

    .DESCRIPTION
    Clones all the repos, runs their setup scripts and sets up gh cli and other dev tools.
#>

[CmdletBinding()]
Param()

if ($env:SLASHKUDOS_PAT) {
    $env:GITHUB_TOKEN = $env:SLASHKUDOS_PAT
    echo 'export GITHUB_TOKEN=$SLASHKUDOS_PAT' >> ~/.bashrc

    New-Item $profile -Type File -Force
    echo '$env:GITHUB_TOKEN = $env:SLASHKUDOS_PAT' >> $profile
}
else {
    Write-Warning "You must set Codespaces secret SLASHKUDOS_PAT"
}

git config --global pull.rebase true

# Auth will use GITHUB_TOKEN environment variable
gh auth login -h github.com
gh auth setup-git -h github.com
gh auth status -t

# Automatically clone public repos
# GITHUB_TOKEN from Codespace cannot be used to clone private repos, must be PAT
gh repo clone slashkudos/kudos-api /workspaces/kudos-api
gh repo clone slashkudos/kudos-site /workspaces/kudos-site
gh repo clone slashkudos/kudos-twitter /workspaces/kudos-twitter
gh repo clone slashkudos/kudos-web /workspaces/kudos-web

# Run repo specific setup scripts
pwsh /workspaces/kudos-api/scripts/Setup-Codespaces.ps1
pwsh /workspaces/kudos-twitter/scripts/Setup-Codespaces.ps1

# Install other dev tools
brew install awscurl

# Ruby related configuration
echo 'export GEM_HOME="$HOME/.gem"' >> ~/.bashrc
echo 'export PATH="$PATH:`ruby -e "puts Gem.user_dir"`/bin"' >> ~/.bashrc
echo '$env:GEM_HOME = "$env:HOME/.gem"' >> $profile
echo '$env:PATH += ":$(ruby -e "puts Gem.user_dir")/bin"' >> $profile
$env:GEM_HOME = "$env:HOME/.gem"
$env:PATH += ":$(ruby -e 'puts Gem.user_dir')/bin"

# Java
echo 'export JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64/bin/java' >> ~/.bashrc

# Node
sudo npm i -g @vercel/ncc@^0.33.1

echo '
{
  "powershell.powerShellAdditionalExePaths": [
    { "exePath": "/usr/local/bin/pwsh", "versionName": "pwsh" }
  ],
  "powershell.powerShellDefaultVersion": "pwsh"
}
' > '/home/vscode/.vscode-remote/data/Machine/settings.json'
