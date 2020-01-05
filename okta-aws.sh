#!/bin/bash
# Usage: publish.sh <tag_name>
# example: /path_to_featurestore_etl/publish.sh 1.4
#          This will produce a docker image and tag it as "1.4"
#          If no argument is given, a default "latest" tag will be assigned to the image.

# Set AWS region
AWS_REGION=eu-west-1

## Verify okta-aws is installed. If not, download and configure it.
if [ ! -f ~/.okta/okta-aws-cli-1.0.10.jar ]; then
    echo "================================="
    echo "== okta-aws jar was not found. =="
    echo "== Downloading jar...          =="
    echo "================================="
	mkdir ~/.okta

	touch ~/.okta/logging.properties
	echo "com.amazonaws.auth.profile.internal.BasicProfileConfigLoader = NONE" > ~/.okta/logging.properties

	touch ~/.okta/config.properties
	echo "OKTA_ORG=gett.okta.com" > ~/.okta/config.properties
	echo "OKTA_AWS_REGION=$AWS_REGION" >> ~/.okta/config.properties
	echo "OKTA_AWS_APP_URL=https://gett.okta.com/home/amazon_aws/0oa37dl4bdug512Re0x7/272" >> ~/.okta/config.properties
    wget -O ~/.okta/okta-aws-cli-1.0.10.jar https://github.com/oktadeveloper/okta-aws-cli-assume-role/releases/download/v1.0.10/okta-aws-cli-1.0.10.jar

    echo "===================================="
    echo "== Finished downloading okta-aws  =="
    echo "===================================="

    echo "Login docker to ECR repository"
    echo "Please enter your okta credentials:"
    $(java -jar ~/.okta/okta-aws-cli-1.0.10.jar ecr get-login --no-include-email --region=$AWS_REGION) --password-stdin

fi

echo "Login to ECR repository (enter your okta credentials if needed)"
$(java -jar ~/.okta/okta-aws-cli-1.0.10.jar ecr get-login --no-include-email --region=$AWS_REGION)
