#!/usr/bin/env bash
# Build and run the Sudoku game in Docker.
#   ./run.sh [run]   build the image and play (default)
#   ./run.sh build   build the image only
#   ./run.sh clean   remove the image and the saved best times
set -euo pipefail

IMAGE="${IMAGE:-sudoku}"
VOLUME="${VOLUME:-sudoku-data}"

cd "$(dirname "${BASH_SOURCE[0]}")"

case "${1:-run}" in
  build)
    docker build -t "$IMAGE" .
    ;;
  run)
    docker build -q -t "$IMAGE" . >/dev/null
    # Needs a terminal of at least 80x24. Best times persist in $VOLUME.
    docker run --rm -it -v "$VOLUME:/data" "$IMAGE"
    ;;
  clean)
    docker rmi "$IMAGE" || true
    docker volume rm "$VOLUME" || true
    ;;
  *)
    echo "usage: $0 [run|build|clean]" >&2
    exit 1
    ;;
esac
