#!/usr/bin/env pwsh

<#
    .SYNOPSIS
    Clones all the repos, runs their setup scripts and sets up gh cli and other dev tools.

    .DESCRIPTION
    Clones all the repos, runs their setup scripts and sets up gh cli and other dev tools.
#>

[CmdletBinding()]
Param()

if($env:SLASHKUDOS_PAT)
{
    $env:GITHUB_TOKEN = $env:SLASHKUDOS_PAT
    echo 'export GITHUB_TOKEN=$SLASHKUDOS_PAT' >> ~/.bashrc

    New-Item $profile -Type File -ErrorAction Ignore
    echo '$env:GITHUB_TOKEN = $env:SLASHKUDOS_PAT' >> $profile
}
else
{
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
