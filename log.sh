#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LOG_FILE="${ROOT_DIR}/logs/marker.log"

if [[ ! -f "${LOG_FILE}" ]]; then
  echo "Log file not found at ${LOG_FILE}"
  echo "Start the application first with ./start.sh"
  exit 1
fi

tail -f "${LOG_FILE}"
