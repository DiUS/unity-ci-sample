#!/bin/bash -eu

file_local='jenkins-config.tar.gz'

# fetch from s3
filename='jenkins/config'
file_remote="${filename}.tar.gz"
bucket='unity-ci-provisioning'

aws s3 cp s3://${bucket}/${file_remote} ./${file_local}

# unpack to current dir
tar -xz -v -f ${file_local} -C .
