#!/bin/bash -eu

node_modules="${HOME}/.local/share/unity3d/Packages/node_modules"
tgz_dir='/opt/Unity/Editor/Data/Resources/Packages'

# echo "node_modules: $node_modules"
# echo "tgz_dir: $tgz_dir"

mkdir -p ${node_modules}
pushd ${node_modules}

cp ${tgz_dir}/*.tgz ./
for file in *.tgz; do
  package_name=`echo ${file} | grep -o '^[-a-z]*' | sed 's/-$//g'`
  # echo "file: ${file}"
  # echo "package: ${package_name}"

  tar -xzf ${file}
  mv package ${package_name}
  rm ${file}
done

popd
