#!/bin/sh
set -eu

agents_raw="${1:-${AO_INSTALL_AGENTS:-claude-code,codex,aider,goose}}"
agents_normalized=$(printf '%s' "$agents_raw" | tr ',' ' ' | xargs)

if [ -z "$agents_normalized" ] || [ "$agents_normalized" = "none" ]; then
  echo "Skipping coding agent installation"
  exit 0
fi

install_claude_code() {
  pnpm install -g @anthropic-ai/claude-code
}

install_codex() {
  pnpm install -g @openai/codex
}

install_aider() {
  curl -LsSf https://aider.chat/install.sh | sh
}

install_goose() {
  curl -fsSL https://github.com/block/goose/releases/download/stable/download_cli.sh |
    CONFIGURE=false bash
}

for agent in $agents_normalized; do
  case "$agent" in
    all)
      install_claude_code
      install_codex
      install_aider
      install_goose
      ;;
    claude-code)
      install_claude_code
      ;;
    codex)
      install_codex
      ;;
    aider)
      install_aider
      ;;
    goose)
      install_goose
      ;;
    "")
      ;;
    *)
      echo "Unsupported coding agent in AO_INSTALL_AGENTS: $agent" >&2
      exit 1
      ;;
  esac
done
