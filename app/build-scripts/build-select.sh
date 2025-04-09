#!/bin/bash

set -e

SCRIPT_NAME=$(basename "$0")
trap 'echo "Exit $SCRIPT_NAME"' EXIT
echo "Running $SCRIPT_NAME..."

if [ ! -f "/.dockerenv" ]; then
  echo "$SCRIPT_NAME: This script is only for use in a devcontainer."
  exit 0
fi

SCRIPT_PATH="$(cd "$(dirname "$0")" && pwd)"
SRC_PATH="$SCRIPT_PATH/../src"
SRC_FILE_NAME="main.go"
SRC_BASENAME="${SRC_FILE_NAME%.go}"
BUILD_ROOT="$SCRIPT_PATH/../build"

# ------------------------
# [ARG PARSING START]
# ------------------------

BUILD_TYPE=""
LINK_TYPE="dynamic"
DEFAULT_TARGETS=""

for arg in "$@"; do
  case "$arg" in
    --build-type=*)
      BUILD_TYPE="${arg#*=}"
      ;;
    --link-type=*)
      LINK_TYPE="${arg#*=}"
      ;;
    --targets=*)
      DEFAULT_TARGETS="${arg#*=}"
      ;;
    *)
      echo "[ERROR] Unknown argument: $arg"
      exit 1
      ;;
  esac
done

if [ -z "$BUILD_TYPE" ]; then
  echo "[ERROR] Please provide --build-type=debug or --build-type=release"
  exit 1
fi

# ------------------------
# [LINK-TYPE COMMON HANDLING]
# ------------------------
if [ "$LINK_TYPE" = "static" ]; then
  CGO_ENABLED_VAL=0
  LDFLAGS="-s -w"
elif [ "$LINK_TYPE" = "dynamic" ]; then
  CGO_ENABLED_VAL=1
  LDFLAGS="-s -w"
else
  echo "[ERROR] Unknown link type: $LINK_TYPE. Use static or dynamic."
  exit 1
fi

# ------------------------
# [DEBUG BUILD]
# ------------------------
if [ "$BUILD_TYPE" = "debug" ]; then
  if [ -n "$DEFAULT_TARGETS" ]; then
    echo "[INFO] --targets option is ignored in debug build."
  fi

  DEBUG_DIR="$BUILD_ROOT/debug"
  mkdir -p "$DEBUG_DIR"
  OUT="$DEBUG_DIR/$SRC_BASENAME"

  echo "[DEBUG] Debug build ($LINK_TYPE link) → $OUT"
  CGO_ENABLED=$CGO_ENABLED_VAL \
  go build -gcflags "all=-N -l" -o "$OUT" "$SRC_PATH/$SRC_FILE_NAME" \
    && echo "[SUCCESS] Debug build success" \
    || echo "[FAILURE] Debug build failed"
  exit $?

# ------------------------
# [RELEASE BUILD (IMMEDIATE OR FZF)]
# ------------------------
elif [ "$BUILD_TYPE" = "release" ]; then
  RELEASE_DIR="$BUILD_ROOT/release"

  TARGET_ARR=()

  if [ -n "$DEFAULT_TARGETS" ]; then
    if [[ "$DEFAULT_TARGETS" =~ ^[[:space:]]*$ ]]; then
      echo "[INFO] --targets is empty, falling back to interactive selection."
    else
      IFS=',' read -ra TARGET_ARR <<< "$DEFAULT_TARGETS"
    fi
  fi

  if [ "${#TARGET_ARR[@]}" -eq 0 ]; then
    SELECTED=$(go tool dist list | fzf --multi --prompt="Select targets: " \
      --header="Use Tab to select multiple targets")
    if [ -z "$SELECTED" ]; then
      echo "[ERROR] No targets selected. Exiting."
      exit 1
    fi
    mapfile -t TARGET_ARR <<< "$SELECTED"
  fi

  for target in "${TARGET_ARR[@]}"; do
    GOOS="${target%%/*}"
    GOARCH="${target##*/}"
    TARGET_DIR="$RELEASE_DIR/${GOARCH}-${GOOS}"
    mkdir -p "$TARGET_DIR"

    OUTFILE="$SRC_BASENAME"
    [ "$GOOS" = "windows" ] && OUTFILE="${OUTFILE}.exe"
    OUT="$TARGET_DIR/$OUTFILE"

    echo "[RELEASE] Building for $GOOS/$GOARCH ($LINK_TYPE link) → $OUT"
    CGO_ENABLED=$CGO_ENABLED_VAL GOOS=$GOOS GOARCH=$GOARCH \
    go build -ldflags="$LDFLAGS" -o "$OUT" "$SRC_PATH/$SRC_FILE_NAME" \
      && echo "[SUCCESS] Success: $target" \
      || echo "[FAILURE] Failed: $target"
  done

  exit 0

else
  echo "[ERROR] Unknown build type: $BUILD_TYPE"
  exit 1
fi
