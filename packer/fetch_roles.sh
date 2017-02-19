#!/bin/bash -eu

clean_and_fetch() {
  author="$1"
  repo="$2"

  rm -rf $repo
  git clone https://github.com/${author}/${repo}
}

fetch_roles() {
  for dir_name in 'git' 'jenkins'; do
    clean_and_fetch 'geerlingguy' "ansible-role-${dir_name}"
  done
  clean_and_fetch 'malk' 'ansible-java8-oracle'
}

sed_inline='--in-place'
os_name=`uname`
if [[ "$os_name" == 'Darwin' ]]; then
  sed_inline="-i '~'"
fi

smash_meta='ansible-role-jenkins/meta/main.yml'
smash_defaults='ansible-role-jenkins/defaults/main.yml'

clean_dependencies() {
  sed $sed_inline 's/dependencies:/#dependencies:/' $smash_meta
  sed $sed_inline 's/ - geerlingguy.java/# - geerlingguy.java/' $smash_meta
}

add_jenkins_plugins() {
  jenkins_plugins='["cloudbees-folder","build-timeout","workflow-aggregator","pipeline-stage-view","git","slack","ansicolor","nunit"]'
  sed $sed_inline "s/jenkins_plugins: \[\]/jenkins_plugins: ${jenkins_plugins}/" $smash_defaults
}

explicit_jenkins_version() {
  sed $sed_inline 's/# jenkins_version: .*$/jenkins_version: "2.13"/' $smash_defaults
}

explicit_jenkins_timezone() {
  sed $sed_inline 's!\(jenkins_java_options: .*\)"$!\1 -Duser.timezone=Australia/Melbourne"!' $smash_defaults
}

pushd ansible/roles

fetch_roles
clean_dependencies
add_jenkins_plugins
explicit_jenkins_version
explicit_jenkins_timezone

popd
