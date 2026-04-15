#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
MARKER_DIR="${ROOT_DIR}/marker"
VENV_DIR="${ROOT_DIR}/.venv"
PYPROJECT_FILE="${ROOT_DIR}/pyproject.toml"

if [[ ! -d "${MARKER_DIR}" ]]; then
  echo "Error: marker submodule directory not found at ${MARKER_DIR}"
  exit 1
fi

if ! command -v uv >/dev/null 2>&1; then
  echo "Error: uv is required but not found in PATH."
  exit 1
fi

if command -v git >/dev/null 2>&1; then
  git -C "${ROOT_DIR}" submodule update --init --recursive marker
fi

if [[ ! -f "${PYPROJECT_FILE}" ]]; then
  uv init "${ROOT_DIR}" --bare --name marker-install --vcs none --no-readme --no-pin-python --no-workspace
fi

if [[ -x "${VENV_DIR}/bin/python" ]]; then
  echo "Using existing virtual environment at ${VENV_DIR}"
else
  uv venv "${VENV_DIR}"
fi

uv add --project "${ROOT_DIR}" --no-workspace --editable "${MARKER_DIR}"
uv add --project "${ROOT_DIR}" --no-workspace uvicorn fastapi python-multipart
uv sync --project "${ROOT_DIR}"

echo "Install complete."
echo "Next step: ./start.sh"
