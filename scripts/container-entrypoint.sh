#!/bin/sh
set -eu

config_path="${AO_CONFIG_PATH:-/app/agent-orchestrator.yaml}"

if [ ! -e "$config_path" ]; then
  echo "Agent Orchestrator config not found at $config_path" >&2
  echo "Create a config file on the host and mount it with AO_CONFIG_FILE." >&2
  exit 1
fi

if [ -d "$config_path" ]; then
  echo "Agent Orchestrator config path is a directory: $config_path" >&2
  echo "This usually means the host path bound via AO_CONFIG_FILE does not exist yet," >&2
  echo "and compose created a directory in its place." >&2
  echo "Create ./agent-orchestrator.yaml first, or set AO_CONFIG_FILE to a real YAML file." >&2
  exit 1
fi

if [ "$#" -eq 0 ]; then
  if [ -n "${AO_PROJECT:-}" ]; then
    set -- start "$AO_PROJECT"
  else
    set -- start
  fi
fi

exec node /app/packages/cli/dist/index.js "$@"
