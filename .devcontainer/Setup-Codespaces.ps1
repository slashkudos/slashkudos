#!/usr/bin/env pwsh

<#
    .SYNOPSIS
    Sets up gh cli and other dev tools.

    .DESCRIPTION
    Sets up gh cli and other dev tools.
#>

[CmdletBinding()]
Param(
  [switch]$Import
)

$ErrorActionPreference = "Stop"

function Invoke-Setup {
  New-Item $profile -Type File -Force

  # git
  Set-GitConfig
  Initialize-Repositories

  # Node and npm
  Install-NodeVersion
  Set-Npmrc
  Install-OtherNpmPackages
  Install-NpmProjectPackages

  # AWS
  Set-AWSProfile
  Install-AwsCurl
  Install-Amplify
  # Needed for amplify mock
  Set-JavaPaths
  Import-AmplifyApplications

  # Other
  Set-RubyPaths
  # Required Ruby gem setup
  Install-Twirl
  Set-PowershellPath

  Write-Host "Setup complete."
}

function Install-NodeVersion {
  curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash; if (!$?) { exit 1 }
  bash -c '
  export NVM_DIR="/usr/local/share/nvm"
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
  [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

  nvm install lts/gallium
  nvm use lts/gallium
  nvm ls
  '
  if (!$?) { exit 1 }
}

function Install-Amplify {
  Write-Host "Installing @aws-amplify/cli@7.6.22"
  sudo npm install -g @aws-amplify/cli@7.6.22; if (!$?) { exit 1 }

  Write-Host "amplify version: " -NoNewLine
  amplify --version
}

function Install-Twirl {
  Write-Host "Installing twurl to help with twitter integration development..."
  # https://github.com/twitter/twurl
  gem install twurl
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
  $repoNames = @("slashkudos/kudos-api", "slashkudos/kudos-twitter", "slashkudos/kudos-web", "slashkudos/kudos-github", "slashkudos/.github")

  foreach ($repo in $repoNames) {
    $workspacePath = "/workspaces/$repo".Replace('slashkudos/', '')
    rm -rf $workspacePath

    Write-Host "Cloning $repo into $workspacePath..."
    gh repo clone "$repo" $workspacePath; if (!$?) { exit 1 }
  }

}

function Set-Npmrc {
  Write-Host "Setting up npmrc for @slashkudos package registry..."
  Write-Output @"
progress=true
email=$(git config --get user.email)
@slashkudos:registry=https://npm.pkg.github.com
//npm.pkg.github.com/:_authToken=$env:GITHUB_TOKEN
"@ > ~/.npmrc
}

function Install-AwsCurl {
  Write-Host "Installing awscurl..."
  brew install awscurl || brew reinstall awscurl
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
}

function Set-JavaPaths {
  Write-Host "Setting JAVA_HOME path..."
  Write-Output 'export JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64/bin/java' >> ~/.bashrc
}

function Install-OtherNpmPackages {
  Write-Host "Installing global npm packages..."
  sudo npm i -g @vercel/ncc@^0.33.1
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

function Import-AmplifyApplications {
  $amplifyApps = @(
    @{
      "name"             = "kudos-api";
      "workingDirectory" = "/workspaces/kudos-api";
      "appId"            = "d5u222qsuh3lu";
      "envName"          = "dev";
    },
    @{
      "name"             = "kudos-api";
      "workingDirectory" = "/workspaces/kudos-api";
      "appId"            = "d5u222qsuh3lu";
      "envName"          = "prod";
      "addEnv"           = $true
    },
    @{
      "name"             = "kudos-twitter";
      "workingDirectory" = "/workspaces/kudos-twitter";
      "appId"            = "d2uh7hyid0jaxm";
      "envName"          = "prod";
    },
    @{
      "name"             = "kudos-web";
      "workingDirectory" = "/workspaces/kudos-web";
      "appId"            = "d1i50fbkdoxw25";
      "envName"          = "dev";
    },
    @{
      "name"             = "kudos-web";
      "workingDirectory" = "/workspaces/kudos-web";
      "appId"            = "d1i50fbkdoxw25";
      "envName"          = "prod";
      "addEnv"           = $true
    }
  )

  foreach ($app in $amplifyApps) {
    Write-Host "Importing $($app.name) $($app.envName)..."
    Set-Location "$($app.workingDirectory)"
    $workingDirectory = $(Get-Location).Path
    Write-Host "Working directory: $workingDirectory"
    if ($app.addEnv) {
      amplify env checkout "$($app.envName)" --yes
    }
    else {
      amplify pull --appId "$($app.appId)" --envName "$($app.envName)" --yes
    }
    if (!$?) { exit 1 }
    Set-Location -
  }
}

function Install-NpmProjectPackages {
  $projectDirectories = @(
    "/workspaces/kudos-api/clients/typescript",
    "/workspaces/kudos-api/scripts/SyncDynamoDB",
    "/workspaces/kudos-twitter",
    "/workspaces/kudos-twitter/amplify/backend/function/twitterwebhookshandler/lib"
    "/workspaces/kudos-web",
  )
  foreach ($dir in $projectDirectories) {
    Write-Host "Invoking npm install in $dir..."
    Set-Location "$dir"
    npm install
    if (!$?) { exit 1 }
    Set-Location -
  }
}

if (!$Import) {
  Invoke-Setup
}
