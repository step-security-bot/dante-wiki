
# Description #

This is a **boiler plate project** to automate **launching a docker** image to Amazon cloud aws 
using a **git commit**.

## Goals ##
* Provide a **set of shell scripts** for automatizing the workflow. 
* Document my learning process in AWS in concepts instead of screenshots of AWS console.

## It does ##
* Setting up a container registry using **ECR Elastic Container Registry**
* Setting up an input source area using **S3**
* Building the docker image using **CodeBuild**
* Informing the user by email on the build process using **SNS** and **CloudWatch**
* Deploying the docker image to Amazon Fargate using **ECS Elastic Container Service**
* Determining the public IP addresses bound to the tasks
* Connecting these IP addresses to a predetermined domain using **Route53**
* Managing the security groups required for the network access
* Setting up the roles providing the necessary permissions using **ECS IAM**
* Setting up an **EFS Elastic Filesystem**
* Uploading files to an **EFS Elastic FIlesystem**


## It does not (yet) ##
* Connecting the scripts to a github push event
* Connecting the service to a Route53 managed domain
* Running some elementary service tests
* Backup the elastic file system

A more detailed description can be found in the
[Wiki](https://github.com/clecap/continuous-deployment-test/wiki).

## Lessons Learned ##
* If things do not work it usually is due to a forgotten configuration parameter. Here this project can help.
* You often forget cleaning up resources somewhere and continue to pay for them. Here this project can help.
* AWS CLI commands have an inconsistent API. Sometimes they expect different parameter formats and the reason is not always clear.


