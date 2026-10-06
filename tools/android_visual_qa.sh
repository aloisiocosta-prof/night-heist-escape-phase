#!/usr/bin/env bash
set -euo pipefail
package=br.prof.aloisiocosta.nightheist.preview
mkdir -p build/visual-android
adb install -r build/qa-android/night-heist-qa.apk
adb logcat -c
activity=$(adb shell cmd package resolve-activity --brief "$package" | tr -d '\r' | tail -1)
adb shell am start -n "$activity"
for attempt in $(seq 1 90); do
  adb logcat -d > build/visual-android/logcat.txt
  if grep -Eq 'QA_PASS|QA_FAIL' build/visual-android/logcat.txt; then break; fi
  sleep 2
done
adb exec-out uiautomator dump /dev/tty > build/visual-android/android-ui.xml || true
adb exec-out screencap -p > build/visual-android/android-screen.png
adb shell run-as "$package" ls files/qa
for name in 01-menu 02-settings-keyboard 03-settings-gamepad 04-settings-touch 05-gameplay-touch 06-skill-check 07-pause; do
  adb exec-out run-as "$package" cat "files/qa/$name.png" > "build/visual-android/$name.png"
  test -s "build/visual-android/$name.png"
done
adb exec-out run-as "$package" cat files/qa/report.json > build/visual-android/report.json
python3 - <<'PY'
import json
from pathlib import Path
report=json.loads(Path('build/visual-android/report.json').read_text())
print(report)
assert report['passed'] and report['platform']=='Android'
PY
if grep -En 'FATAL EXCEPTION|QA_FAIL|SCRIPT ERROR:|Program linking failed' build/visual-android/logcat.txt; then exit 1; fi
