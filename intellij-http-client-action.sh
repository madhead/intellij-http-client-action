#!/usr/bin/env bash

function option {
  local -n _options=$1
  local _name=$2
  local _value=$3

  if [[ ! -z "$_value" ]]; then
    _options+=("--$_name=$_value")
  fi
}

function flag {
  local -n _options=$1
  local _name=$2
  local _value=$3

  if [[ "$_value" == "true" ]]; then
    _options+=("--$_name")
  fi
}

function values {
  local -n _options=$1
  local _name=$2
  local _value=$3

  declare -a _values

  if [[ ! -z "$_value" ]]; then
    while IFS=$'\n' read -r value ; do
      _options+=("--$_name=$value")
    done <<< "$_value"    
  fi
}

declare -a files

while IFS=$'\n' read -r file ; do
    files+=("$file");
done <<< "$INPUT_FILES"

declare -a options

option options 'socket-timeout' "${INPUT_SOCKET_TIMEOUT}"
option options 'connect-timeout' "${INPUT_CONNECT_TIMEOUT}"
flag options 'insecure' "${INPUT_INSECURE}"

option options 'env' "${INPUT_ENV}"
option options 'env-file' "${INPUT_ENV_FILE}"
values options 'env-variables' "${INPUT_ENV_VARIABLES}"
option options 'private-env-file' "${INPUT_PRIVATE_ENV_FILE}"
values options 'private-env-variables' "${INPUT_PRIVATE_ENV_VARIABLES}"

# https://youtrack.jetbrains.com/issue/IDEA-314789/IntelliJ-HTTP-Client-ignores-proxy-settings
option options 'proxy' "${INPUT_PROXY}"

flag options 'docker-mode' "${INPUT_DOCKER_MODE}"
option options 'log-level' "${INPUT_LOG_LEVEL}"
flag options 'report' "${INPUT_REPORT}"

(
  set -x;
  java \
    -cp '/intellij-http-client/*' \
    com.intellij.httpClient.cli.HttpClientMain \
    "${options[@]}" \
    -- \
    "${files[@]}"
)
