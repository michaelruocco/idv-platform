# IDV Platform

[![Build](https://github.com/michaelruocco/idv-platform/workflows/pipeline/badge.svg)](https://github.com/michaelruocco/idv-platform/actions)

## Overview

This is a repo for integration testing and deploying to components of the IDV platform to AWS. So far the
platform includes the following services:

* [idv-context](https://github.com/michaelruocco/idv-context)
* [idv-one-time-passcode](https://github.com/michaelruocco/idv-one-time-passcode)

## TODO

*   Fix cloud formation templates to remove duplication of things like hostname when setting 
    CONTEXT_URI in otp service
*   Change deployment to use a task-definition rather than pushing to latest docker
    image version and using force-new-deployment to refresh service
*   Try using EC2 ECS cluster instead of Fargate as it will likely be cheaper
*   Look into exposing services through API or updating load balancer to use HTTPS instead of HTTP

### Running the platform locally

To run the platform on your local machine you can run the gradle task that will use docker compose to run
the platform services together.

```
./gradlew composeUp
```

To spin it back down again you can run:

```
./gradlew composeDown
```

### Testing the platform locally

The command below will spin up the services, run the postman collections testing the platform
locally and then spin the services back down again.

```
./gradlew composeUp localEnvPostman composeDown
```

## AWS

### Testing the platform against AWS

The command below will run the postman collections testing the platform deployed in AWS.

```
./gradlew composeUp testEnvPostman composeDown
```

The below commands can be used to use cloudformation to deploy the service on AWS.
A great description of how these templates work is [here](https://reflectoring.io/aws-cloudformation-deploy-docker-image/).

#### Creating AWS resources

```aws
//generate network resources using cloud formation
aws cloudformation create-stack --stack-name idv-test-network --template-body file://cloud-formation/network.yml --capabilities CAPABILITY_IAM
```

```aws
//generate service resources using cloud formation (relies on network stack already being created)
aws cloudformation create-stack --stack-name idv-test-context-service --template-body file://cloud-formation/context-service.yml --parameters ParameterKey=MongoConnectionString,ParameterValue=<mongo-connection-string>
aws cloudformation create-stack --stack-name idv-test-one-time-passcode-service --template-body file://cloud-formation/one-time-passcode-service.yml --parameters ParameterKey=MongoConnectionString,ParameterValue=<mongo-connection-string>
```

#### Update image used by running task

```aws
aws ecs update-service --cluster idv-test --service idv-context --force-new-deployment
aws ecs update-service --cluster idv-test --service idv-one-time-passcode --force-new-deployment
```

#### Deleting AWS resources

```aws
aws cloudformation delete-stack --stack-name idv-test-context-service;
aws cloudformation delete-stack --stack-name idv-test-one-time-passcode-service;
aws cloudformation delete-stack --stack-name idv-test-network;
```
