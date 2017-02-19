#! /bin/bash -eu
. helper.sh

cleanCache
cacheOutputs 'vpc'
cacheOutputs 'iam'

AMI_ID_JENKINS='ami-linuxami' # check https://aws.amazon.com/amazon-linux-ami/

p1=`parameterKVP vpc VpcId`
p2=`parameterKVP vpc SubnetAPublicId`
p3=`parameterKVP vpc SubnetBPublicId`
p4=`parameterKVP vpc SubnetCPublicId`
p5=`parameterKVP vpc SecurityGroupDefaultId SecurityGroupVpcDefaultId`
p6=`parameterKVP iam JenkinsInstanceProfileId JenkinsMasterProfileId`
pAMI=`buildParameterKVP AmiId $AMI_ID_JENKINS`

parameters="$p1 $p2 $p3 $p4 $p5 $p6 $pAMI"

aws cloudformation update-stack \
  --stack-name unity-ci-jenkins-master \
  --template-body file://jenkins.json \
  --parameters $parameters
