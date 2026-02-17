#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
DATE="$(date +%Y-%m-%d)"

BYBIT_SRC="$ROOT_DIR/sources/bybit.rules"
GATE_SRC="$ROOT_DIR/sources/gate.rules"
APPLE_ARCADE_SRC="$ROOT_DIR/sources/apple_arcade.rules"

normalize_rules() {
  local src="$1"
  awk '
    {
      sub(/\r$/, "")
    }
    /^[[:space:]]*$/ { next }
    /^[[:space:]]*#/ { next }
    {
      if (!seen[$0]++) print $0
    }
  ' "$src"
}

write_text_header() {
  local out="$1"
  local name="$2"
  cat > "$out" <<EOT
# NAME: $name
# AUTHOR: Lxp1986
# UPDATED: $DATE
EOT
}

write_clash_yaml() {
  local src="$1"
  local out="$2"
  local name="$3"
  cat > "$out" <<EOT
# NAME: $name
# AUTHOR: Lxp1986
# UPDATED: $DATE

rules:
EOT
  while IFS= read -r rule; do
    printf '  - %s\n' "$rule" >> "$out"
  done < <(normalize_rules "$src")
}

write_surge_list() {
  local src="$1"
  local out="$2"
  local name="$3"
  write_text_header "$out" "$name"
  normalize_rules "$src" >> "$out"
}

write_qx_list() {
  local src="$1"
  local out="$2"
  local name="$3"
  write_text_header "$out" "$name"
  normalize_rules "$src" | sed -e 's/^DOMAIN-SUFFIX,/HOST-SUFFIX,/' -e 's/^DOMAIN-KEYWORD,/HOST-KEYWORD,/' >> "$out"
}

write_surge_list "$BYBIT_SRC" "$ROOT_DIR/surge/bybit.list" "bybit"
write_surge_list "$GATE_SRC" "$ROOT_DIR/surge/gate.list" "gate"

write_surge_list "$GATE_SRC" "$ROOT_DIR/shadowrocket/gate.list" "gate"
write_surge_list "$BYBIT_SRC" "$ROOT_DIR/loon/bybit.list" "bybit"
write_surge_list "$GATE_SRC" "$ROOT_DIR/loon/gate.list" "gate"
write_surge_list "$APPLE_ARCADE_SRC" "$ROOT_DIR/loon/apple_arcade.list" "apple_arcade"

write_qx_list "$BYBIT_SRC" "$ROOT_DIR/qx/bybit.list" "bybit"
write_qx_list "$GATE_SRC" "$ROOT_DIR/qx/gate.list" "gate"

write_clash_yaml "$BYBIT_SRC" "$ROOT_DIR/clash/Bybit.yaml" "bybit"
write_clash_yaml "$GATE_SRC" "$ROOT_DIR/clash/gate.yaml" "gate"

echo "Rules synced successfully."
