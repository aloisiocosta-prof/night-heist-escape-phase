#!/usr/bin/env bash
set -euo pipefail
version=4.4.1
base="https://github.com/godotengine/godot-builds/releases/download/${version}-stable"
curl --fail --location --retry 3 "$base/Godot_v${version}-stable_linux.x86_64.zip" -o "$RUNNER_TEMP/godot.zip"
curl --fail --location --retry 3 "$base/Godot_v${version}-stable_export_templates.tpz" -o "$RUNNER_TEMP/templates.zip"
unzip -q "$RUNNER_TEMP/godot.zip" -d "$RUNNER_TEMP/godot-bin"
echo "$RUNNER_TEMP/godot-bin" >> "$GITHUB_PATH"
unzip -q "$RUNNER_TEMP/templates.zip" -d "$RUNNER_TEMP/godot-templates"
mkdir -p "$HOME/.local/share/godot/export_templates/${version}.stable"
cp -r "$RUNNER_TEMP/godot-templates/templates/"* "$HOME/.local/share/godot/export_templates/${version}.stable/"
ln -s "$RUNNER_TEMP/godot-bin/Godot_v${version}-stable_linux.x86_64" "$RUNNER_TEMP/godot-bin/godot"
