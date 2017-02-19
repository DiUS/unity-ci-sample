#! /bin/bash -eu

aws cloudformation update-stack \
  --stack-name unity-ci-vpc \
  --template-body file://vpc.json
