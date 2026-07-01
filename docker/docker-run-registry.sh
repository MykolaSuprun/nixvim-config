#!/usr/bin/env bash
# docker-run-registry.sh — run nixvim from Docker Hub. No Nix required.
#
# Works with Docker or Colima (auto-detected; override with DOCKER_CMD).
#
# Usage:
#   docker-run-registry.sh [PROFILE] [--] [NVIM_ARGS...]
#
#   PROFILE is one of: nixvim, lazyvim, codevim  (default: nixvim)
#   Everything after -- is passed directly to nvim inside the container.
#
# Examples:
#   docker-run-registry.sh
#   docker-run-registry.sh lazyvim -- .
#   docker-run-registry.sh codevim -- src/main.rs
#   docker-run-registry.sh -- +"Telescope find_files"
#
# This script does NOT build with Nix — it pulls from Docker Hub only.
# If you need offline/local builds, use docker-run.sh instead.

set -euo pipefail

DEFAULT_PROFILE="nixvim"
VALID_PROFILES=("nixvim" "lazyvim" "codevim")
DOCKERHUB_USER="mykolasuprun"
DOCKERHUB_REPO="nixvim"
WORKSPACE="/workspace"

# ---------------------------------------------------------------------------
# Detect container runtime: colima > docker
# ---------------------------------------------------------------------------

if [[ -n "${DOCKER_CMD:-}" ]]; then
  CMD="$DOCKER_CMD"
elif command -v colima &>/dev/null; then
  CMD="colima"
else
  CMD="docker"
fi

if ! command -v "$CMD" &>/dev/null; then
  echo "Error: container runtime '$CMD' not found. Install docker or colima, or set DOCKER_CMD." >&2
  exit 1
fi

# If using colima, ensure it's running
if [[ "$CMD" == "colima" ]]; then
  if ! colima status &>/dev/null; then
    echo "[docker-run-registry] Colima is not running. Starting it now..."
    colima start
  fi
fi

# ---------------------------------------------------------------------------
# Helpers
# ---------------------------------------------------------------------------

is_valid_profile() {
  local p="$1"
  for vp in "${VALID_PROFILES[@]}"; do
    [[ "$p" == "$vp" ]] && return 0
  done
  return 1
}

# ---------------------------------------------------------------------------
# Argument parsing
# ---------------------------------------------------------------------------

PROFILE=""
NVIM_ARGS=()
PASSTHROUGH=0

for arg in "$@"; do
  if [[ "$PASSTHROUGH" -eq 1 ]]; then
    NVIM_ARGS+=("$arg")
    continue
  fi
  if [[ "$arg" == "--" ]]; then
    PASSTHROUGH=1
    continue
  fi
  if [[ -z "$PROFILE" ]] && is_valid_profile "$arg"; then
    PROFILE="$arg"
    continue
  fi
  PASSTHROUGH=1
  NVIM_ARGS+=("$arg")
done

PROFILE="${PROFILE:-$DEFAULT_PROFILE}"

if [[ ${#NVIM_ARGS[@]} -eq 0 ]]; then
  NVIM_ARGS=(".")
fi

IMAGE="${DOCKERHUB_USER}/${DOCKERHUB_REPO}:${PROFILE}-latest"

# ---------------------------------------------------------------------------
# Pull and run
# ---------------------------------------------------------------------------

echo "[docker-run-registry] Using runtime: $CMD"
echo "[docker-run-registry] Pulling ${IMAGE}..."
"$CMD" pull "$IMAGE"

DOCKER_ARGS=(
  --rm
  -it
  -v "$PWD:$WORKSPACE"
  -w "$WORKSPACE"
)

for var in TERM COLORTERM BAT_THEME STYLIX_COLORSCHEME TMUX TMUX_PANE; do
  if [[ -n "${!var:-}" ]]; then
    DOCKER_ARGS+=(-e "$var")
  fi
done

if [[ -f "$HOME/.gitconfig" ]]; then
  DOCKER_ARGS+=(-v "$HOME/.gitconfig:/root/.gitconfig:ro")
fi

if [[ -d "$HOME/.ssh" ]]; then
  DOCKER_ARGS+=(-v "$HOME/.ssh:/root/.ssh:ro")
fi

if [[ -n "${TMUX:-}" ]]; then
  TMUX_SOCKET="${TMUX%%,*}"
  if [[ -S "$TMUX_SOCKET" ]]; then
    CONTAINER_SOCK="/tmp/tmux.sock"
    DOCKER_ARGS+=(-v "$TMUX_SOCKET:$CONTAINER_SOCK:ro")
    DOCKER_ARGS+=(-e "TMUX=$CONTAINER_SOCK")
  fi
fi

set -x
"$CMD" run "${DOCKER_ARGS[@]}" "$IMAGE" "${NVIM_ARGS[@]}"

