
setup() {
  export DATE=$(date +%s%N)
  docker pull alpine:3.7 >&2
  docker build --build-arg version="$DATE" tests/example-build >&2
}

teardown () {
  if [ "$status" -eq 0 ]; then
    echo teardown log
    echo "status: $status"
    printf '%s\n' "${my_array[@]}"
    echo teardown done
  fi
}

@test "reconnect to same builder" {
  run docker build --memory-swap=-1 --build-arg version="$DATE" tests/example-build
  [ "$status" -eq 0 ]
  [ "${lines[7]}" = " ---> Using cache" ]
  [ "${lines[10]}" = " ---> Using cache" ]
  [[ "${lines[12]}" =~ Successfully.* ]]
}