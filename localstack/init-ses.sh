#!/bin/bash

aws ses verify-email-identity --email-address idv.demo.mail@gmail.com --region eu-west-1 --endpoint-url=http://localhost:4566
aws ses verify-email-identity --email-address michael.ruocco@hotmail.com --region eu-west-1 --endpoint-url=http://localhost:4566