
load test_helper

@test "do not update cache from tag" {
  export DOCKER_HOST=tcp://builder-0.builder:2375
  docker pull alpine:3.7 >&2
  docker build --build-arg version="$DATE" -t test-tag-$DATE:1st tests/example-build >&2
  docker tag test-tag-$DATE:1st test-tag-$DATE >&2
  echo "{\"HttpHeaders\": {\"GitBranchName\": \"branchname-$DATE-2nd\"}}" > $HOME/.docker/config.json
  export DOCKER_HOST=tcp://builder-1.builder:2375
  docker pull alpine:3.7 >&2
  run docker build --memory-swap=-1 --build-arg version="$DATE" -t test-tag-$DATE:2nd tests/example-build
  [ "$status" -eq 0 ]
  [ "${lines[7]}" != " ---> Using cache" ]
  [ "${lines[10]}" != " ---> Using cache" ]
  [[ "${lines[12]}" =~ Successfully.* ]]
  [[ "${lines[13]}" =~ Successfully.* ]]
}
