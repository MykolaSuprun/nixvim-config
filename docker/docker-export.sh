#!/usr/bin/env bash
# docker-export.sh — build, load, and export a Docker image as a portable tar.gz.
#
# Usage:
#   docker-export.sh [PROFILE]
#
#   PROFILE is one of: nixvim, lazyvim, codevim  (default: nixvim)
#
# Examples:
#   docker-export.sh              # exports nixvim image
#   docker-export.sh lazyvim      # exports lazyvim image
#   docker-export.sh codevim      # exports codevim image
#
# Output:  <profile>-docker.tar.gz  in the current directory.
# Transfer: scp nixvim-docker.tar.gz target:/tmp && gunzip < /tmp/nixvim-docker.tar.gz | docker load

set -euo pipefail

DEFAULT_PROFILE="nixvim"
VALID_PROFILES=("nixvim" "lazyvim" "codevim")
IMAGE_TAG="latest"

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

IMAGE_NAME="$profile"
FLAKE_TARGET="docker-$profile"
OUTPUT_FILE="${profile}-docker.tar.gz"

echo "[docker-export] Building ${FLAKE_TARGET}..."
RESULT_PATH=$(nix build ".#${FLAKE_TARGET}" --no-link --print-out-paths)

echo "[docker-export] Loading image into Docker..."
docker load < "$RESULT_PATH"

echo "[docker-export] Exporting to ${OUTPUT_FILE}..."
docker save "${IMAGE_NAME}:${IMAGE_TAG}" | gzip > "$OUTPUT_FILE"

echo "[docker-export] Done."
echo ""
echo "File: $(realpath "$OUTPUT_FILE")"
echo "Size: $(du -h "$OUTPUT_FILE" | cut -f1)"
echo ""
echo "To transfer and load on another machine:"
echo "  scp ${OUTPUT_FILE} target:/tmp"
echo "  ssh target 'gunzip < /tmp/${OUTPUT_FILE} | docker load'"
echo "  ssh target 'docker run --rm -it ${IMAGE_NAME}:${IMAGE_TAG}'"

