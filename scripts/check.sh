#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)
cd "$SCRIPT_DIR/.."
FLUTTER="$PWD/flutter/bin/flutter"
DART="$PWD/flutter/bin/dart"

if [[ ! -x "$FLUTTER" ]]; then
    echo 'Initialize the Flutter submodule with git submodule update --init --recursive.' >&2
    exit 1
fi

"$FLUTTER" --version
"$FLUTTER" pub get
"$FLUTTER" analyze --no-pub
"$DART" format --output=none --set-exit-if-changed -l 200 lib test
rm -f coverage/lcov.info
"$FLUTTER" test --no-pub --coverage --coverage-package='^markdown_editor$'
