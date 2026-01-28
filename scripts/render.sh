#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

MAMBA_BIN="$ROOT_DIR/.tools/micromamba"
MAMBA_ROOT_PREFIX="$ROOT_DIR/.micromamba"
ENV_NAME="nphd9040"

if [[ ! -x "$MAMBA_BIN" ]]; then
  echo "Missing $MAMBA_BIN" >&2
  echo "Run: scripts/bootstrap-env.sh" >&2
  exit 1
fi

echo "Rendering Quarto website -> docs/" >&2
"$MAMBA_BIN" -r "$MAMBA_ROOT_PREFIX" run -n "$ENV_NAME" quarto render
