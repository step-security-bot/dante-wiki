
# Description #

This is a boiler plate project to automate launching a docker image to Amazon cloud aws 
using a set of shell script commands. It documents learning processes in Amazon AWS.

**It does:**
* Setting up a container registry using **ECR Elastic Container Registry**
* Setting up an input source area using **S3**
* Building the docker image using **CodeBuild**
* Informing the user by email on the build process using **SNS** and **CloudWatch**
* Deploying the docker image to Amazon Fargate using **ECS Elastic Container Service**
* Determining the public IP addresses bound to the tasks
* Connecting these IP addresses to a predetermined domain using **Route53**
* Managing the security groups required for the network access
* Setting up the roles providing the necessary permissions using **ECS IAM**


**Todo:
* Connecting the scripts to a github push event
* Connecting the service to a Route53 managed domain
* Running some elementary service tests

A more detailed description can be found in the
[Wiki](https://github.com/clecap/continuous-deployment-test/wiki).




