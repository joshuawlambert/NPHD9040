#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

TOOLS_DIR="$ROOT_DIR/.tools"
MAMBA_ROOT_PREFIX="$ROOT_DIR/.micromamba"
ENV_NAME="nphd9040"

MAMBA_BIN="$TOOLS_DIR/micromamba"

mkdir -p "$TOOLS_DIR" "$MAMBA_ROOT_PREFIX"

if [[ ! -x "$MAMBA_BIN" ]]; then
  OS="$(uname -s | tr '[:upper:]' '[:lower:]')"
  ARCH="$(uname -m)"

  case "$ARCH" in
    x86_64|amd64) ARCH="64" ;;
    aarch64|arm64) ARCH="aarch64" ;;
    *)
      echo "Unsupported arch: $ARCH" >&2
      exit 1
      ;;
  esac

  URL="https://micro.mamba.pm/api/micromamba/${OS}-${ARCH}/latest"

  echo "Downloading micromamba to $MAMBA_BIN" >&2
  TMP_ARCHIVE="$TOOLS_DIR/micromamba.tar.bz2"
  curl -fsSL "$URL" -o "$TMP_ARCHIVE"

  # Some minimal environments don't have bzip2 available for tar -j.
  TOOLS_DIR="$TOOLS_DIR" TMP_ARCHIVE="$TMP_ARCHIVE" python3 - <<'PY'
import bz2
import os
import tarfile
from pathlib import Path

tools_dir = Path(os.environ["TOOLS_DIR"]).resolve()
archive_path = Path(os.environ["TMP_ARCHIVE"]).resolve()

data = bz2.decompress(archive_path.read_bytes())
with tarfile.open(fileobj=__import__("io").BytesIO(data), mode="r:") as tf:
    member = tf.getmember("bin/micromamba")
    tf.extract(member, path=tools_dir)

src = tools_dir / "bin" / "micromamba"
dst = tools_dir / "micromamba"
dst.write_bytes(src.read_bytes())
dst.chmod(0o755)
PY
  rm -f "$TMP_ARCHIVE"
  rm -rf "$TOOLS_DIR/bin"
  chmod +x "$MAMBA_BIN"
fi

echo "Creating/updating micromamba env: $ENV_NAME" >&2
"$MAMBA_BIN" -r "$MAMBA_ROOT_PREFIX" create -y -n "$ENV_NAME" -c conda-forge \
  quarto \
  r-base \
  r-knitr \
  r-rmarkdown \
  r-readxl \
  r-ggplot2 \
  r-dplyr \
  r-tidyr \
  r-car \
  r-emmeans \
  r-ez \
  r-vcd \
  r-treemap \
  r-maps \
  r-tm \
  r-wordcloud \
  r-pwr \
  r-shiny

echo "Installing any missing CRAN packages (fallback)" >&2
"$MAMBA_BIN" -r "$MAMBA_ROOT_PREFIX" run -n "$ENV_NAME" Rscript -e 'pkgs <- c(
  "car","emmeans","ez","readxl","ggplot2","dplyr","tidyr","vcd","treemap","maps","tm","wordcloud","pwr","shiny"
); inst <- rownames(installed.packages()); miss <- setdiff(pkgs, inst);
if (length(miss)) install.packages(miss, repos = "https://cloud.r-project.org");
cat("Missing after install:", paste(setdiff(pkgs, rownames(installed.packages())), collapse = ", "), "\n")'

echo "Toolchain versions:" >&2
"$MAMBA_BIN" -r "$MAMBA_ROOT_PREFIX" run -n "$ENV_NAME" quarto --version
"$MAMBA_BIN" -r "$MAMBA_ROOT_PREFIX" run -n "$ENV_NAME" R --version | head -n 2
