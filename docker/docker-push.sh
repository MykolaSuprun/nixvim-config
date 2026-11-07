#!/usr/bin/env bash
# docker-push.sh — build and push Docker images to Docker Hub.
#
# Usage:
#   docker-push.sh [PROFILE]
#
#   PROFILE is one of: nixvim, codevim  (default: nixvim)
#
# Examples:
#   docker-push.sh              # push nixvim image
#   docker-push.sh codevim      # push codevim image
#
# Prerequisites:
#   • Docker Hub login:  docker login -u mykolasuprun
#   • Nix installed (for building the image)
#
# Pushes to: mykolasuprun/nixvim:<profile>-latest

set -euo pipefail

DEFAULT_PROFILE="nixvim"
VALID_PROFILES=("nixvim" "codevim")
LOCAL_TAG="latest"
DOCKERHUB_USER="mykolasuprun"
DOCKERHUB_REPO="nixvim"

profile="${1:-$DEFAULT_PROFILE}"

# Validate profile
valid=0
for vp in "${VALID_PROFILES[@]}"; do
  [[ "$profile" == "$vp" ]] && valid=1 && break
done

if [[ "$valid" -eq 0 ]]; then
  echo "Error: unknown profile '$profile'. Valid profiles: ${VALID_PROFILES[*]}" >&2
  exit 1
fi

LOCAL_IMAGE="${profile}:${LOCAL_TAG}"
REMOTE_IMAGE="${DOCKERHUB_USER}/${DOCKERHUB_REPO}:${profile}-latest"
FLAKE_TARGET="docker-${profile}"

echo "[docker-push] Building ${FLAKE_TARGET}..."
RESULT_PATH=$(nix build ".#${FLAKE_TARGET}" --no-link --print-out-paths)

echo "[docker-push] Loading image into Docker..."
docker load < "$RESULT_PATH"

echo "[docker-push] Tagging ${LOCAL_IMAGE} → ${REMOTE_IMAGE}..."
docker tag "$LOCAL_IMAGE" "$REMOTE_IMAGE"

echo "[docker-push] Pushing ${REMOTE_IMAGE}..."
docker push "$REMOTE_IMAGE"

echo "[docker-push] Done."
echo ""
echo "Pushed: ${REMOTE_IMAGE}"
echo ""
echo "Pull on another machine:"
echo "  docker pull ${REMOTE_IMAGE}"
echo "  docker run --rm -it ${REMOTE_IMAGE}"

