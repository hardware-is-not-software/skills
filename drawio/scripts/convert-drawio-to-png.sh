#!/usr/bin/env bash
set -euo pipefail

print_install_help() {
  cat >&2 <<'HELP'
Draw.io CLI was not found.

Install options:
1) macOS (Homebrew):
   brew install --cask drawio

2) Linux:
   - Debian/Ubuntu package or snap package
   - Common binaries after install: drawio, drawio-desktop, /snap/bin/drawio

3) Windows:
   - Install draw.io desktop (diagrams.net)
   - Common paths:
     C:\Program Files\draw.io\draw.io.exe
     C:\Users\<you>\AppData\Local\Programs\draw.io\draw.io.exe

4) Manual download:
   https://www.diagrams.net/

After install, verify one of these works:
  drawio --version
  draw.io --version
  drawio-desktop --version

Then rerun this script.
HELP
}

resolve_drawio_cmd() {
  # PATH-based detection first
  if command -v drawio >/dev/null 2>&1; then
    echo "drawio"
    return 0
  fi

  if command -v draw.io >/dev/null 2>&1; then
    echo "draw.io"
    return 0
  fi

  if [[ -x "/Applications/draw.io.app/Contents/MacOS/draw.io" ]]; then
    echo "/Applications/draw.io.app/Contents/MacOS/draw.io"
    return 0
  fi

  # Linux common paths/binaries
  if command -v drawio-desktop >/dev/null 2>&1; then
    echo "drawio-desktop"
    return 0
  fi

  if [[ -x "/usr/bin/drawio" ]]; then
    echo "/usr/bin/drawio"
    return 0
  fi

  if [[ -x "/usr/bin/draw.io" ]]; then
    echo "/usr/bin/draw.io"
    return 0
  fi

  if [[ -x "/snap/bin/drawio" ]]; then
    echo "/snap/bin/drawio"
    return 0
  fi

  if [[ -x "/usr/local/bin/drawio" ]]; then
    echo "/usr/local/bin/drawio"
    return 0
  fi

  # Windows (Git Bash/Cygwin/MSYS) common paths
  if command -v draw.io.exe >/dev/null 2>&1; then
    echo "draw.io.exe"
    return 0
  fi

  if [[ -n "${PROGRAMFILES:-}" ]] && [[ -x "${PROGRAMFILES}/draw.io/draw.io.exe" ]]; then
    echo "${PROGRAMFILES}/draw.io/draw.io.exe"
    return 0
  fi

  if [[ -n "${PROGRAMFILES(X86):-}" ]] && [[ -x "${PROGRAMFILES(X86)}/draw.io/draw.io.exe" ]]; then
    echo "${PROGRAMFILES(X86)}/draw.io/draw.io.exe"
    return 0
  fi

  if [[ -n "${LOCALAPPDATA:-}" ]] && [[ -x "${LOCALAPPDATA}/Programs/draw.io/draw.io.exe" ]]; then
    echo "${LOCALAPPDATA}/Programs/draw.io/draw.io.exe"
    return 0
  fi

  if [[ -x "/c/Program Files/draw.io/draw.io.exe" ]]; then
    echo "/c/Program Files/draw.io/draw.io.exe"
    return 0
  fi

  if [[ -x "/c/Program Files (x86)/draw.io/draw.io.exe" ]]; then
    echo "/c/Program Files (x86)/draw.io/draw.io.exe"
    return 0
  fi

  # WSL paths to Windows installation
  if [[ -x "/mnt/c/Program Files/draw.io/draw.io.exe" ]]; then
    echo "/mnt/c/Program Files/draw.io/draw.io.exe"
    return 0
  fi

  if [[ -x "/mnt/c/Program Files (x86)/draw.io/draw.io.exe" ]]; then
    echo "/mnt/c/Program Files (x86)/draw.io/draw.io.exe"
    return 0
  fi

  return 1
}

usage() {
  cat >&2 <<'USAGE'
Usage:
  scripts/convert-drawio-to-png.sh <file1.drawio> [file2.drawio ...]

Environment variables:
  DRAWIO_SCALE   Export scale (default: 2)
USAGE
}

if [[ $# -lt 1 ]]; then
  usage
  exit 1
fi

if ! drawio_cmd="$(resolve_drawio_cmd)"; then
  print_install_help
  exit 127
fi

scale="${DRAWIO_SCALE:-2}"
failures=0

for input in "$@"; do
  if [[ ! -f "$input" ]]; then
    echo "Skipping missing file: $input" >&2
    failures=$((failures + 1))
    continue
  fi

  case "$input" in
    *.drawio)
      output="${input%.drawio}.drawio.png"
      ;;
    *.xml)
      output="${input%.xml}.png"
      ;;
    *)
      output="${input}.png"
      ;;
  esac

  echo "Converting $input -> $output"
  err_file="$(mktemp)"
  if ! "$drawio_cmd" -x -f png -s "$scale" -t -o "$output" "$input" >"$err_file" 2>&1; then
    echo "Failed to export PNG for: $input" >&2
    if [[ -s "$err_file" ]]; then
      echo "draw.io output:" >&2
      sed -n '1,80p' "$err_file" >&2
    fi
    cat >&2 <<'TROUBLESHOOT'
Troubleshooting:
- Confirm draw.io opens once interactively, then retry export.
- Try the app binary directly (platform-specific):
  macOS:   /Applications/draw.io.app/Contents/MacOS/draw.io -x -f png -s 2 -t -o out.png input.drawio
  Linux:   /usr/bin/drawio -x -f png -s 2 -t -o out.png input.drawio
  Windows: "C:\Program Files\draw.io\draw.io.exe" -x -f png -s 2 -t -o out.png input.drawio
- Reinstall draw.io if the CLI crashes.
TROUBLESHOOT
    rm -f "$err_file"
    failures=$((failures + 1))
    continue
  fi
  rm -f "$err_file"

  echo "Wrote $output"
done

if [[ "$failures" -gt 0 ]]; then
  echo "Completed with $failures failure(s)." >&2
  exit 1
fi

echo "All exports completed successfully."
