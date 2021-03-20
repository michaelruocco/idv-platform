# IDV Platform

[![Build](https://github.com/michaelruocco/idv-platform/workflows/pipeline/badge.svg)](https://github.com/michaelruocco/idv-platform/actions)

## Overview

This is a repo for integration testing and deploying to components of the IDV platform to AWS. So far the
platform includes the following services:

* [idv-context](https://github.com/michaelruocco/idv-context)
* [idv-one-time-passcode](https://github.com/michaelruocco/idv-one-time-passcode)

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

The command below will spin up the services, run the postman collections testing the platform and then
spin the services back down again.

```
./gradlew composeUp postman composeDown
```

### AWS

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
aws cloudformation create-stack --stack-name idv-test-otp-service --template-body file://cloud-formation/otp-service.yml --parameters ParameterKey=MongoConnectionString,ParameterValue=<mongo-connection-string>
```

#### Update image used by running task

```aws
aws ecs update-service --cluster idv-test --service idv-context --force-new-deployment
```

#### Deleting AWS resources

```aws
aws cloudformation delete-stack --stack-name idv-test-context-service;
aws cloudformation delete-stack --stack-name idv-test-otp-service;
aws cloudformation delete-stack --stack-name idv-test-network;
```
