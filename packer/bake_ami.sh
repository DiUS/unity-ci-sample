#!/bin/bash -eu

. ../cloudformation/helper.sh

cleanCache
cacheOutputs jenkins-master
export JENKINS_AMI_ID=`getOutputValue AmiId jenkins-master`

# Use your own incremental AMI here, if you add stuff often:
# export JENKINS_AMI_ID='ami-ricotta'

packer build jenkins-packer.json
