#!/usr/bin/env bash

set -euo pipefail

RUN_PUBLISH_DRY_RUN=false

for arg in "$@"; do
  case "$arg" in
    --publish-dry-run)
      RUN_PUBLISH_DRY_RUN=true
      ;;
    *)
      echo "Unknown argument: $arg" >&2
      echo "Usage: $0 [--publish-dry-run]" >&2
      exit 2
      ;;
  esac
done

echo "[quality] Installing dependencies"
dart pub get

echo "[quality] Verifying formatting"
dart format --output=none --set-exit-if-changed .

echo "[quality] Running static analysis (fatal infos/warnings)"
dart analyze --fatal-infos --fatal-warnings

echo "[quality] Running tests"
dart test

if [[ "$RUN_PUBLISH_DRY_RUN" == "true" ]]; then
  echo "[quality] Running publish dry-run"
  dart pub publish --dry-run
fi
