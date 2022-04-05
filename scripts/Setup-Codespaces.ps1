#!/usr/bin/env pwsh

<#
    .SYNOPSIS
    Sets up gh cli and other dev tools.

    .DESCRIPTION
    Sets up gh cli and other dev tools.
#>

[CmdletBinding()]
Param()

function Invoke-Setup {
  # git
  Set-GitConfig
  Initialize-Repositories

  # Node and npm
  Install-Node
  Set-Npmrc
  Install-OtherNpmPackages

  # AWS
  Set-AWSProfile
  Install-AwsCurl
  Install-Amplify
  # Needed for amplify mock
  Set-JavaPaths

  # Other
  Set-RubyPaths
  # Required Ruby gem setup
  Install-Twirl
  Set-PowershellPath
}

function Install-Node {
  nvm install lts/gallium
  nvm use lts/gallium
}

function Install-Amplify {
  sudo npm install -g @aws-amplify/cli@7.6.22

  Write-Host "amplify version: " -NoNewLine
  amplify --version
}

function Install-Twirl {
  Write-Host "Installing twurl to help with twitter integration development..."
  # https://github.com/twitter/twurl
  gem install twurl
  Write-Host "Done."
}

function Set-AWSProfile {
  # Setup AWS default profile
  mkdir -p ~/.aws

  Write-Output @"
[default]
region=us-east-1
"@ > ~/.aws/config

  if ($env:AWS_ACCESS_KEY_ID -and $env:AWS_SECRET_ACCESS_KEY) {
    Write-Output @"
[default]
aws_access_key_id = $env:AWS_ACCESS_KEY_ID
aws_secret_access_key = $env:AWS_SECRET_ACCESS_KEY
"@ > ~/.aws/credentials
  }
  else {
    Write-Warning "User's Codespace environment variables AWS_ACCESS_KEY_ID and AWS_SECRET_ACCESS_KEY not set. `nRunning 'aws configure'"
  }  

  aws configure list
}

function Initialize-Repositories {
  Write-Host "Cloning repos..."
  $env:GITHUB_TOKEN | gh auth login --with-token
  gh repo clone slashkudos/kudos-api /workspaces/kudos-api; if (!$?) { exit 1 }
  gh repo clone slashkudos/kudos-site /workspaces/kudos-site; if (!$?) { exit 1 }
  gh repo clone slashkudos/kudos-twitter /workspaces/kudos-twitter; if (!$?) { exit 1 }
  gh repo clone slashkudos/kudos-web /workspaces/kudos-web; if (!$?) { exit 1 }
  Write-Host "Done."
}

function Set-Npmrc {
  Write-Host "Setting up npmrc for @slashkudos package registry..."
  Write-Output @"
progress=true
email=$(git config --get user.email)
@slashkudos:registry=https://npm.pkg.github.com
//npm.pkg.github.com/:_authToken=$env:GITHUB_TOKEN
"@ > ~/.npmrc
  Write-Host "Done."
}

function Install-AwsCurl {
  Write-Host "Installing awscurl..."
  brew install awscurl
  Write-Host "Done."
}

function Set-GitConfig {
  git config --global pull.rebase true
}

function Set-RubyPaths {
  Write-Host "Configuring Ruby Gems..."
  Write-Output 'export GEM_HOME="$HOME/.gem"' >> ~/.bashrc
  Write-Output 'export PATH="$PATH:`ruby -e "puts Gem.user_dir"`/bin"' >> ~/.bashrc
  Write-Output '$env:GEM_HOME = "$env:HOME/.gem"' >> $profile
  Write-Output '$env:PATH += ":$(ruby -e "puts Gem.user_dir")/bin"' >> $profile
  $env:GEM_HOME = "$env:HOME/.gem"
  $env:PATH += ":$(ruby -e 'puts Gem.user_dir')/bin"
  Write-Host "Done."
}

function Set-JavaPaths {
  Write-Host "Setting JAVA_HOME path..."
  Write-Output 'export JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64/bin/java' >> ~/.bashrc
  Write-Host "Done."
}

function Install-OtherNpmPackages {
  Write-Host "Installing global npm packages..."
  sudo npm i -g @vercel/ncc@^0.33.1
  Write-Host "Done."
}

function Set-PowershellPath {
  # Fix finnicky powershell path issues
  Write-Output '
{
  "powershell.powerShellAdditionalExePaths": [
    { "exePath": "/usr/local/bin/pwsh", "versionName": "pwsh" }
  ],
  "powershell.powerShellDefaultVersion": "pwsh"
}
' > '/home/vscode/.vscode-remote/data/Machine/settings.json'
}

Invoke-Setup
