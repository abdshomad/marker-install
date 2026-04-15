# AGENTS

## Scope
This repository is a thin wrapper around the `marker` git submodule and provides operational shell scripts to install and run the Marker API server.

## Project Layout
- `marker/`: upstream Marker submodule
- `install.sh`: prepares uv project and dependencies
- `start.sh`: starts API server in background
- `stop.sh`: stops API server processes
- `restart.sh`: stop then start
- `log.sh`: tails runtime logs
- `pyproject.toml` and `uv.lock`: root uv project metadata

## Operational Rules
- Use `uv` for Python environment and dependencies.
- Reuse existing `.venv` if present; do not recreate unless explicitly requested.
- Keep runtime files in:
  - `.run/marker.pid`
  - `logs/marker.log`
- Do not modify submodule internals in `marker/` for wrapper-level changes.

## Typical Workflow
1. `./install.sh`
2. `./start.sh`
3. `./log.sh`
4. `./stop.sh` or `./restart.sh`

## Validation
When changing management scripts, validate with:
- `bash -n install.sh start.sh stop.sh restart.sh log.sh`
- Execute scripts in sequence: install -> start -> log -> restart -> stop
