# codebuild-windows-dotnet

This repository contains the definition for building a Visual Studio 2019 toolchain in a Windows Server Core 2019 container that should be suitable for use with AWS CodeBuild.

Image base: `mcr.microsoft.com/windows/servercore:ltsc2019`

Refer to packages.config for the software installed in the container.

## Deployment to ECR

1. Clone this repository.

2. Build the container.

   ```bash
   docker build . -t codebuild-windows-dotnet:latest
   ```

3. Log in to ECR (make sure you have the AWS CLI installed).

   ```powershell
   Invoke-Expression -Command (aws ecr get-login --no-include-email)
   ```

4. Tag the container build with your ECR repository and tag.

   ```bash
   docker image tag codebuild-windows-dotnet:latest [YOUR_ACCOUNT_NUMBER].dkr.ecr.[YOUR_REGION].amazonaws.com/codebuild-windows-dotnet
   ```

5. Push the image.

   ```bash
   docker image push [YOUR_ACCOUNT_NUMBER].dkr.ecr.[YOUR_REGION].amazonaws.com/codebuild-windows-dotnet
   ```

## Use with CodeBuild

In the root directory of your source repository, create a YAML file named buildspec.yml with the following contents:

```yaml
version: 0.2

phases:
  pre_build:
    commands:
      - New-Item -ItemType Junction -Path C:\Src -Value $Env:CODEBUILD_SRC_DIR
      - cd C:\Src  
      - nuget.exe restore
  build:
    commands:
      - msbuild
```