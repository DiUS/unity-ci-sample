#!/bin/bash -eu

file_local='jenkins-config.tar.gz'

# archive current config
configs=`find jobs | grep config.xml`
tar -cz -v -f ${file_local} credentials.xml users ${configs}

# send to s3
date_now=`date "+%Y-%m-%d_%H-%M-%S"`
filename='jenkins/config'
file_remote="${filename}.tar.gz"
file_remote_dated="${filename}_${date_now}.tar.gz"
bucket='unity-ci-provisioning'

aws s3 cp ${file_local} s3://${bucket}/${file_remote}
aws s3 cp ${file_local} s3://${bucket}/${file_remote_dated}
