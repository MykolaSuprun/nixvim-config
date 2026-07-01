#!/usr/bin/env bash
# docker-run.sh — run nixvim Docker images with sensible defaults.
#
# Usage:
#   docker-run.sh [PROFILE] [--] [NVIM_ARGS...]
#
#   PROFILE is one of: nixvim, lazyvim, codevim  (default: nixvim)
#   Everything after -- is passed directly to nvim inside the container.
#   If no -- is given, PROFILE is detected heuristically; remaining args go to nvim.
#
# Examples:
#   docker-run.sh                         # opens current directory in nixvim
#   docker-run.sh .                       # same
#   docker-run.sh file.rs                 # opens file.rs
#   docker-run.sh lazyvim -- .            # opens current dir in lazyvim
#   docker-run.sh codevim -- src/main.rs  # opens file in codevim
#   docker-run.sh -- +"Telescope find_files"
#   docker-run.sh nixvim -- --headless -c "echo 'hello' | q"
#
# Automatic behaviours:
#   • Builds and loads the Docker image if not already present.
#   • Mounts $PWD → /workspace (default target).
#   • Forwards TERM, COLORTERM, BAT_THEME, STYLIX_COLORSCHEME, TMUX, TMUX_PANE.
#   • Mounts ~/.gitconfig and ~/.ssh (read-only) when they exist.
#   • Auto-detects tmux and forwards the tmux socket when inside tmux.

set -euo pipefail

# ---------------------------------------------------------------------------
# Configuration
# ---------------------------------------------------------------------------

DEFAULT_PROFILE="nixvim"
VALID_PROFILES=("nixvim" "lazyvim" "codevim")
IMAGE_TAG="latest"
WORKSPACE="/workspace"

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
  # First non-profile, non-separator arg → the rest are nvim args
  PASSTHROUGH=1
  NVIM_ARGS+=("$arg")
done

PROFILE="${PROFILE:-$DEFAULT_PROFILE}"

# Default to opening current directory if no nvim args given
if [[ ${#NVIM_ARGS[@]} -eq 0 ]]; then
  NVIM_ARGS=(".")
fi

IMAGE_NAME="$PROFILE"
FLAKE_TARGET="docker-$PROFILE"

# ---------------------------------------------------------------------------
# Build / load image
# ---------------------------------------------------------------------------

echo "[docker-run] Using profile: $PROFILE"

if ! docker image inspect "${IMAGE_NAME}:${IMAGE_TAG}" &>/dev/null; then
  echo "[docker-run] Image ${IMAGE_NAME}:${IMAGE_TAG} not found. Building..."
  nix build ".#${FLAKE_TARGET}" --no-link --print-out-paths >/dev/null
  RESULT_PATH=$(nix build ".#${FLAKE_TARGET}" --no-link --print-out-paths)
  echo "[docker-run] Loading image into Docker..."
  docker load < "$RESULT_PATH"
  echo "[docker-run] Image loaded."
else
  echo "[docker-run] Image ${IMAGE_NAME}:${IMAGE_TAG} already present."
fi

# ---------------------------------------------------------------------------
# Assemble docker run flags
# ---------------------------------------------------------------------------

DOCKER_ARGS=(
  --rm
  -it
  -v "$PWD:$WORKSPACE"
  -w "$WORKSPACE"
)

# Environment variables (forward if set on host)
for var in TERM COLORTERM BAT_THEME STYLIX_COLORSCHEME TMUX TMUX_PANE; do
  if [[ -n "${!var:-}" ]]; then
    DOCKER_ARGS+=(-e "$var")
  fi
done

# Git config (read-only, only if exists)
if [[ -f "$HOME/.gitconfig" ]]; then
  DOCKER_ARGS+=(-v "$HOME/.gitconfig:/root/.gitconfig:ro")
fi

# SSH keys (read-only, only if exists)
if [[ -d "$HOME/.ssh" ]]; then
  DOCKER_ARGS+=(-v "$HOME/.ssh:/root/.ssh:ro")
fi

# Tmux socket forwarding (auto-detect when inside tmux)
if [[ -n "${TMUX:-}" ]]; then
  TMUX_SOCKET="${TMUX%%,*}"
  if [[ -S "$TMUX_SOCKET" ]]; then
    # Mount socket to a predictable path inside the container
    CONTAINER_SOCK="/tmp/tmux.sock"
    DOCKER_ARGS+=(-v "$TMUX_SOCKET:$CONTAINER_SOCK:ro")
    DOCKER_ARGS+=(-e "TMUX=$CONTAINER_SOCK")
  fi
fi

# ---------------------------------------------------------------------------
# Run
# ---------------------------------------------------------------------------

set -x
docker run "${DOCKER_ARGS[@]}" "${IMAGE_NAME}:${IMAGE_TAG}" "${NVIM_ARGS[@]}"

