
# Description #

This is a boiler plate project to automate launching a docker image to Amazon cloud aws 
using a set of shell script commands. It documents learning processes in Amazon AWS.

It automates the tasks of
* Setting up a container registry using '''ECR Elastic Container Registry'''
* Setting up an input source area using '''S3'''
* Building the docker image using '''CodeBuild'''
* Informing the user by email on the build process using '''SNS''' and '''CloudWatch'''
* Deploying the docker image to Amazon Fargate using '''ECS Elastic Container Service'''
* Using the docker image

Todo:
* Connecting the scripts to a github push event


A more detailed description can be found in the
[Wiki](https://github.com/clecap/continuous-deployment-test/wiki).




