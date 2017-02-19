#! /bin/bash -eu

aws cloudformation update-stack \
  --capabilities CAPABILITY_IAM \
  --stack-name unity-ci-iam \
  --template-body file://iam.json
