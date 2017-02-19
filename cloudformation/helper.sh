cleanCache() {
  rm -f cache*
}

cacheOutputs() {
  stack="$1"
  aws cloudformation describe-stacks \
    --stack-name unity-ci-${stack} \
    > cache_${stack}.json

  jq '[.Stacks[0].Outputs[] | { key: .OutputKey, value: .OutputValue }] | from_entries' \
    < cache_${stack}.json \
    > cache_${stack}_outputs.json
}

getOutputValue() {
  lookupKey="$1"
  stack="$2"
  jq ".$lookupKey" < cache_${stack}_outputs.json | tr -d '"'
}

buildParameterKVP() {
  outputKey="$1"
  value="$2"
  echo "ParameterKey=$outputKey,ParameterValue=$value"
}

parameterKVP() {
  stack="$1"
  lookupKey="$2"
  outputKey="$lookupKey"

  if [[ "$#" = 3 ]]; then
    outputKey="$3"
  fi

  value=`getOutputValue $lookupKey $stack`
  buildParameterKVP $outputKey $value
}
