
load test_helper

@test "use cache from same branch" {
  export DOCKER_HOST=tcp://builder-0.builder:2375
  docker pull alpine:3.7 >&2
  docker build --build-arg version="$DATE" -t cache-from-same-branch:$DATE tests/example-build >&2
  export DOCKER_HOST=tcp://builder-1.builder:2375
  docker pull alpine:3.7 >&2
  run docker build --memory-swap=-1 --build-arg version="$DATE" -t cache-from-same-branch:$DATE tests/example-build
  [ "$status" -eq 0 ]
  [ "${lines[7]}" = " ---> Using cache" ]
  [ "${lines[10]}" = " ---> Using cache" ]
  [[ "${lines[12]}" =~ Successfully.* ]]
  [[ "${lines[13]}" =~ Successfully.* ]]
}
