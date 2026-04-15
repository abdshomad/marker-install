#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
VENV_DIR="${ROOT_DIR}/.venv"
RUN_DIR="${ROOT_DIR}/.run"
LOG_DIR="${ROOT_DIR}/logs"
PID_FILE="${RUN_DIR}/marker.pid"
LOG_FILE="${LOG_DIR}/marker.log"
PORT="${PORT:-8001}"

mkdir -p "${RUN_DIR}" "${LOG_DIR}"

if ! command -v uv >/dev/null 2>&1; then
  echo "Error: uv is required but not found in PATH."
  exit 1
fi

if [[ ! -f "${ROOT_DIR}/pyproject.toml" || ! -d "${VENV_DIR}" ]]; then
  echo "Error: uv project environment not found. Run ./install.sh first."
  exit 1
fi

if [[ ! -x "${VENV_DIR}/bin/marker_server" ]]; then
  echo "Error: marker_server not found in ${VENV_DIR}. Run ./install.sh first."
  exit 1
fi

if [[ -f "${PID_FILE}" ]]; then
  OLD_PID="$(<"${PID_FILE}")"
  if [[ -n "${OLD_PID}" ]] && kill -0 "${OLD_PID}" 2>/dev/null; then
    echo "Marker is already running (pid: ${OLD_PID})."
    echo "Use ./log.sh to view logs or ./restart.sh to restart."
    exit 0
  fi
  rm -f "${PID_FILE}"
fi

nohup "${VENV_DIR}/bin/marker_server" --port "${PORT}" >>"${LOG_FILE}" 2>&1 &
NEW_PID=$!
echo "${NEW_PID}" > "${PID_FILE}"

echo "Marker started."
echo "PID: ${NEW_PID}"
echo "Port: ${PORT}"
echo "Log: ${LOG_FILE}"
