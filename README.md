# IDV Platform

[![Build](https://github.com/michaelruocco/idv-platform/workflows/pipeline/badge.svg)](https://github.com/michaelruocco/idv-platform/actions)
[![codecov](https://codecov.io/gh/michaelruocco/idv-platform/branch/master/graph/badge.svg?token=FWDNP534O7)](https://codecov.io/gh/michaelruocco/idv-platform)
[![Codacy Badge](https://app.codacy.com/project/badge/Grade/272889cf707b4dcb90bf451392530794)](https://www.codacy.com/gh/michaelruocco/idv-platform/dashboard?utm_source=github.com&amp;utm_medium=referral&amp;utm_content=michaelruocco/idv-platform&amp;utm_campaign=Badge_Grade)
[![BCH compliance](https://bettercodehub.com/edge/badge/michaelruocco/idv-platform?branch=master)](https://bettercodehub.com/)
[![Quality Gate Status](https://sonarcloud.io/api/project_badges/measure?project=michaelruocco_idv-platform&metric=alert_status)](https://sonarcloud.io/dashboard?id=michaelruocco_idv-platform)
[![Technical Debt](https://sonarcloud.io/api/project_badges/measure?project=michaelruocco_idv-platform&metric=sqale_index)](https://sonarcloud.io/dashboard?id=michaelruocco_idv-platform)
[![Coverage](https://sonarcloud.io/api/project_badges/measure?project=michaelruocco_idv-platform&metric=coverage)](https://sonarcloud.io/dashboard?id=michaelruocco_idv-platform)
[![Lines of Code](https://sonarcloud.io/api/project_badges/measure?project=michaelruocco_idv-platform&metric=ncloc)](https://sonarcloud.io/dashboard?id=michaelruocco_idv-platform)
[![Maven Central](https://img.shields.io/maven-central/v/com.github.michaelruocco/idv-platform.svg?label=Maven%20Central)](https://search.maven.org/search?q=g:%22com.github.michaelruocco%22%20AND%20a:%22idv-platform%22)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

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
