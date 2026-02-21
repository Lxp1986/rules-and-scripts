#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
DATE="$(date +%Y-%m-%d)"
BASE_URL="https://raw.githubusercontent.com/Lxp1986/rules-and-scripts/refs/heads/master"

RULES=(bybit gate pubgm bigo apple_arcade)

normalize_rules() {
  local src="$1"
  awk '
    { sub(/\r$/, "") }
    /^[[:space:]]*$/ { next }
    /^[[:space:]]*#/ { next }
    { if (!seen[$0]++) print $0 }
  ' "$src"
}

write_text_header() {
  local out="$1"
  local name="$2"
  mkdir -p "$(dirname "$out")"
  cat > "$out" <<EOT
# NAME: $name
# AUTHOR: Lxp1986
# UPDATED: $DATE
EOT
}

write_list() {
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

write_clash_yaml() {
  local src="$1"
  local out="$2"
  local name="$3"
  mkdir -p "$(dirname "$out")"
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

write_rule_readme() {
  local out="$1"
  local title="$2"
  local url="$3"
  cat > "$out" <<EOT
# $title

订阅链接：
$url
EOT
}

ensure_source() {
  local source_file="$1"
  if [ ! -f "$source_file" ]; then
    echo "Missing source: $source_file" >&2
    exit 1
  fi
}

# Build all rules for each platform with matching syntax.
for rule in "${RULES[@]}"; do
  src="$ROOT_DIR/sources/${rule}.rules"
  ensure_source "$src"

  # Surge
  surge_dir="$ROOT_DIR/surge/$rule"
  surge_file="$surge_dir/${rule}.list"
  write_list "$src" "$surge_file" "$rule"
  write_rule_readme "$surge_dir/README.md" "Surge - $rule" "$BASE_URL/surge/$rule/${rule}.list"

  # Shadowrocket
  sr_dir="$ROOT_DIR/shadowrocket/$rule"
  sr_file="$sr_dir/${rule}.list"
  write_list "$src" "$sr_file" "$rule"
  write_rule_readme "$sr_dir/README.md" "Shadowrocket - $rule" "$BASE_URL/shadowrocket/$rule/${rule}.list"

  # Loon
  loon_dir="$ROOT_DIR/loon/$rule"
  loon_file="$loon_dir/${rule}.list"
  write_list "$src" "$loon_file" "$rule"
  write_rule_readme "$loon_dir/README.md" "Loon - $rule" "$BASE_URL/loon/$rule/${rule}.list"

  # Stash
  stash_dir="$ROOT_DIR/stash/$rule"
  stash_file="$stash_dir/${rule}.list"
  write_list "$src" "$stash_file" "$rule"
  write_rule_readme "$stash_dir/README.md" "Stash - $rule" "$BASE_URL/stash/$rule/${rule}.list"

  # Quantumult X
  qx_dir="$ROOT_DIR/qx/$rule"
  qx_file="$qx_dir/${rule}.list"
  write_qx_list "$src" "$qx_file" "$rule"
  write_rule_readme "$qx_dir/README.md" "Quantumult X - $rule" "$BASE_URL/qx/$rule/${rule}.list"

  # Clash
  clash_dir="$ROOT_DIR/clash/$rule"
  clash_file="$clash_dir/${rule}.yaml"
  write_clash_yaml "$src" "$clash_file" "$rule"
  write_rule_readme "$clash_dir/README.md" "Clash - $rule" "$BASE_URL/clash/$rule/${rule}.yaml"

done

echo "Rules synced successfully."
