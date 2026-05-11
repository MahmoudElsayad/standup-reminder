#!/bin/bash
set -euo pipefail

cd "$(dirname "$0")"

START=$(python3 -c "import time; print(int(time.time() * 1000))")

# Clean build
make clean > /dev/null 2>&1
mkdir -p .build

# Compile
swiftc \
  -sdk "$(xcrun --show-sdk-path --sdk macosx)" \
  -F "$(xcrun --show-sdk-path --sdk macosx)/System/Library/Frameworks" \
  -framework AppKit \
  -framework UserNotifications \
  -framework SwiftUI \
  -Xlinker -rpath -Xlinker /usr/lib/swift \
  -target arm64-apple-macosx14.0 \
  -parse-as-library \
  -Osize \
  -wmo \
  -o .build/StandUpReminder \
  Sources/*.swift \
  2>&1 | tee .build/warnings.txt

WARNING_COUNT=$(grep -c "warning:" .build/warnings.txt 2>/dev/null || echo 0)

END=$(python3 -c "import time; print(int(time.time() * 1000))")
BUILD_TIME_MS=$((END - START))
BUILD_TIME_S=$(python3 -c "print($BUILD_TIME_MS / 1000.0)")

# Binary size
SIZE_KB=0
if [ -f .build/StandUpReminder ]; then
  SIZE_KB=$(du -k .build/StandUpReminder | cut -f1)
fi

echo "METRIC build_time_s=${BUILD_TIME_S}"
echo "METRIC warning_count=${WARNING_COUNT}"
echo "METRIC binary_size_kb=${SIZE_KB}"
