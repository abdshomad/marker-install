#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PID_FILE="${ROOT_DIR}/.run/marker.pid"
SERVER_PATTERN="${ROOT_DIR}/.venv/bin/marker_server"
UV_PATTERN="uv run --project ${ROOT_DIR} marker_server"
STOPPED_ANY=0

stop_pid() {
  local target_pid="$1"
  if [[ -z "${target_pid}" ]]; then
    return 0
  fi

  if ! kill -0 "${target_pid}" 2>/dev/null; then
    return 0
  fi

  STOPPED_ANY=1
  kill "${target_pid}" 2>/dev/null || true

  for _ in {1..20}; do
    if ! kill -0 "${target_pid}" 2>/dev/null; then
      return 0
    fi
    sleep 1
  done

  kill -9 "${target_pid}" 2>/dev/null || true
}

if [[ -f "${PID_FILE}" ]]; then
  PID="$(<"${PID_FILE}")"
  if [[ -n "${PID}" ]]; then
    stop_pid "${PID}"
  fi
  rm -f "${PID_FILE}"
fi

while IFS= read -r extra_pid; do
  if [[ -n "${extra_pid}" && "${extra_pid}" != "$$" ]]; then
    stop_pid "${extra_pid}"
  fi
done < <(pgrep -f "${SERVER_PATTERN}" || true)

while IFS= read -r extra_pid; do
  if [[ -n "${extra_pid}" && "${extra_pid}" != "$$" ]]; then
    stop_pid "${extra_pid}"
  fi
done < <(pgrep -f "${UV_PATTERN}" || true)

if [[ "${STOPPED_ANY}" -eq 1 ]]; then
  echo "Marker stopped."
else
  echo "Marker is not running."
fi
