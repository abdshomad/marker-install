# marker-install

Wrapper repository for running the Marker API server from a git submodule, with simple lifecycle scripts.

## Requirements

- `git`
- `uv` (for Python environment and dependency management)

## Repository Structure

- `marker/`: Marker submodule source
- `install.sh`: initialize submodule and install dependencies with uv
- `start.sh`: run Marker API server in background
- `stop.sh`: stop server and clean stale processes
- `restart.sh`: stop then start
- `log.sh`: tail server log output

## Quick Start

```bash
./install.sh
./start.sh
```

Default server URL: `http://127.0.0.1:8001`  
OpenAPI docs: `http://127.0.0.1:8001/docs`

## Script Usage

### Install

```bash
./install.sh
```

What it does:
- ensures `marker` submodule is initialized
- creates root `pyproject.toml` with `uv init` if missing
- reuses existing `.venv` if already present
- installs local editable `marker` package
- installs API dependencies (`uvicorn`, `fastapi`, `python-multipart`)
- runs `uv sync`

### Start

```bash
./start.sh
```

Optional custom port:

```bash
PORT=8002 ./start.sh
```

Runtime files:
- PID: `.run/marker.pid`
- Log: `logs/marker.log`

### Stop

```bash
./stop.sh
```

Stops the PID-managed process and any stray local Marker server process started from this repo.

### Restart

```bash
./restart.sh
```

### Logs

```bash
./log.sh
```

## Notes

- First startup may take longer due to model downloads.
- If dependencies change, run `./install.sh` again.