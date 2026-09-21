# Java Web App Deployment with AWS CI/CD

An end-to-end CI/CD pipeline on AWS that automatically builds a Java web app from GitHub and deploys it to Tomcat on Amazon EC2.

<br>

## Table of Contents
- [Introduction](#introduction)
- [How the Pipeline Works](#how-the-pipeline-works)
- [Technologies](#technologies)
- [Setup](#setup)
- [Troubleshooting Log](#troubleshooting-log)
- [Contact](#contact)
- [Conclusion](#conclusion)

<br>

## Introduction
This project builds and deploys a Java-based web app using AWS's CI/CD tools.

The end user never sees the deployment pipeline, but it automates the whole release process: every push to this repository is built, packaged, and deployed to EC2 with no manual steps.

<br>

## How the Pipeline Works

```
GitHub (push) → CodePipeline → CodeBuild → CodeDeploy → EC2 (Tomcat)
```

1. **Source:** A push to the `master` branch triggers CodePipeline.
2. **Build:** CodeBuild pulls dependencies from CodeArtifact, compiles the app with Maven, and packages the WAR file, `appspec.yml`, and deployment scripts.
3. **Deploy:** CodeDeploy copies the WAR to the EC2 instance and runs the lifecycle hooks in `scripts/`:
   - `ApplicationStop`: stops Tomcat if it's running
   - `BeforeInstall`: installs Tomcat if it's missing and clears the old app
   - `ApplicationStart`: enables and restarts Tomcat to serve the new version

<br>

## Technologies

- **Amazon EC2**: Hosts both the development environment and the deployed app, so development and deployment happen entirely in the cloud.
- **VS Code**: My IDE. It connects to my development EC2 instance over Remote-SSH, so I can edit code and manage files in the cloud.
- **GitHub**: Stores and versions all of the app's code, and is the source stage of the pipeline.
- **AWS CodeArtifact**: Stores the project's Maven dependencies, so builds are faster and don't rely on public repositories.
- **AWS CodeBuild**: Compiles the source code, runs tests, and packages the app as a WAR file, using `buildspec.yml`.
- **AWS CodeDeploy**: Deploys the WAR to Tomcat on EC2 using `appspec.yml`. Lifecycle hooks in `scripts/` install and restart Tomcat automatically.
- **AWS CodePipeline**: Connects everything, so each push to GitHub automatically builds and deploys the app.
- **AWS Systems Manager (Session Manager)**: Gives shell access to EC2 instances without SSH keys or an open port 22.

<br>

## Setup
To get this project up and running on your local machine, follow these steps:

1. Clone the repository:
    ```bash
    git clone https://github.com/jlcherian/nextwork-web-project.git
    ```
2. Navigate to the project directory:
    ```bash
    cd nextwork-web-project
    ```
3. Install dependencies:
    ```bash
    mvn install
    ```

<br>

## Troubleshooting Log
Getting this pipeline working end to end meant fixing several real deployment failures:

- **Deploy stage failing with "agent did not receive the lifecycle event":** The CodeDeploy agent was actually running; the real cause was network connectivity. I found this by connecting through SSM Session Manager, since the instance had been launched without a key pair.
- **"AppSpec file not found" at BeforeInstall:** The repo had no `appspec.yml`, and `buildspec.yml` only packaged the WAR file. I added `appspec.yml` and included it in the build artifacts.
- **App unreachable after a successful deployment:** Tomcat was never installed, so CodeDeploy was copying the WAR into a folder with nothing to serve it. I added a `BeforeInstall` hook that installs Tomcat automatically, and opened port 8080 in the security group.
- **SSH timing out from VS Code:** The security group only allowed port 22 from an old IP address. I restricted the rule to my current IP rather than opening it to the internet.

<br>

## Contact
If you have any questions or comments about this project, please contact:
Joel - [jlcherian@yahoo.com](mailto:jlcherian@yahoo.com)

<br>

## Conclusion
Thank you for exploring this project! I'll keep improving this pipeline and apply what I learned to future projects.

A big shoutout to **[NextWork](https://learn.nextwork.org/app)** for their project guide and support. [You can get started with this DevOps series project too by clicking here.](https://learn.nextwork.org/projects/aws-devops-vscode?track=high)
