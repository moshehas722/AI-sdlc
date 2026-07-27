#!/usr/bin/env bash
# scan-dependencies.sh — deterministic dependency manifest scanner (Unix)
# Outputs JSON to stdout. Never guess versions; only parse known manifest formats.

set -euo pipefail

ROOT="${1:-$(cd "$(dirname "$0")/../.." && pwd)}"
SCANNED_AT="$(date -u +"%Y-%m-%dT%H:%M:%SZ")"

manifests=()
packages_json='[]'

add_manifest() {
  local rel="$1"
  local found=0
  for m in "${manifests[@]:-}"; do
    [[ "$m" == "$rel" ]] && found=1 && break
  done
  [[ $found -eq 0 ]] && manifests+=("$rel")
}

# npm package.json via node if available
if command -v node >/dev/null 2>&1; then
  while IFS= read -r -d '' f; do
    rel="${f#"$ROOT"/}"
    add_manifest "$rel"
    node -e "
      const fs=require('fs');
      const j=JSON.parse(fs.readFileSync(process.argv[1],'utf8'));
      const out=[];
      for (const [scope,key] of [['runtime','dependencies'],['dev','devDependencies'],['peer','peerDependencies'],['optional','optionalDependencies']]) {
        const block=j[key]; if(!block) continue;
        for (const [name,version] of Object.entries(block)) out.push({name,version,scope,source:process.argv[2]});
      }
      console.log(JSON.stringify(out));
    " "$f" "$rel" 2>/dev/null | while read -r chunk; do
      packages_json="$(node -e "const a=JSON.parse(process.argv[1]); const b=JSON.parse(process.argv[2]); console.log(JSON.stringify(a.concat(b)))" "$packages_json" "$chunk")"
    done
  done < <(find "$ROOT" -name package.json -not -path '*/node_modules/*' -not -path '*/.context/*' -print0 2>/dev/null)
fi

# requirements.txt
while IFS= read -r -d '' f; do
  rel="${f#"$ROOT"/}"
  add_manifest "$rel"
  while IFS= read -r line; do
    line="$(echo "$line" | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')"
    [[ -z "$line" || "$line" =~ ^# || "$line" =~ ^-r ]] && continue
    if [[ "$line" =~ ^([a-zA-Z0-9_.-]+)(==|>=|<=|~=|!=|>|<)(.+)$ ]]; then
      packages_json="$(node -e "const a=JSON.parse(process.argv[1]); a.push({name:process.argv[2],version:process.argv[3],scope:'runtime',source:process.argv[4]}); console.log(JSON.stringify(a))" "$packages_json" "${BASH_REMATCH[1]}" "${BASH_REMATCH[3]}" "$rel" 2>/dev/null || echo "$packages_json")"
    elif [[ "$line" =~ ^([a-zA-Z0-9_.-]+)$ ]]; then
      packages_json="$(node -e "const a=JSON.parse(process.argv[1]); a.push({name:process.argv[2],version:'(unpinned)',scope:'runtime',source:process.argv[4]}); console.log(JSON.stringify(a))" "$packages_json" "${BASH_REMATCH[1]}" "(unpinned)" "$rel" 2>/dev/null || echo "$packages_json")"
    fi
  done < "$f"
done < <(find "$ROOT" -name 'requirements*.txt' -not -path '*/.venv/*' -not -path '*/venv/*' -not -path '*/.context/*' -print0 2>/dev/null)

# go.mod
while IFS= read -r -d '' f; do
  rel="${f#"$ROOT"/}"
  add_manifest "$rel"
  in_req=0
  while IFS= read -r line; do
    [[ "$line" =~ require[[:space:]]*\( ]] && in_req=1 && continue
    [[ $in_req -eq 1 && "$line" =~ ^[[:space:]]*\) ]] && in_req=0 && continue
    if [[ $in_req -eq 1 && "$line" =~ ^[[:space:]]*([^[:space:]]+)[[:space:]]+([^[:space:]]+) ]]; then
      packages_json="$(node -e "const a=JSON.parse(process.argv[1]); a.push({name:process.argv[2],version:process.argv[3],scope:'runtime',source:process.argv[4]}); console.log(JSON.stringify(a))" "$packages_json" "${BASH_REMATCH[1]}" "${BASH_REMATCH[2]}" "$rel" 2>/dev/null || echo "$packages_json")"
    fi
  done < "$f"
done < <(find "$ROOT" -name go.mod -not -path '*/.context/*' -print0 2>/dev/null)

manifests_json='[]'
for m in "${manifests[@]:-}"; do
  manifests_json="$(node -e "const a=JSON.parse(process.argv[1]); a.push(process.argv[2]); console.log(JSON.stringify(a))" "$manifests_json" "$m" 2>/dev/null || echo '[]')"
done

node -e "
  console.log(JSON.stringify({
    scanned_at: process.argv[1],
    root: process.argv[2],
    manifests: JSON.parse(process.argv[3]),
    packages: JSON.parse(process.argv[4])
  }, null, 2));
" "$SCANNED_AT" "$ROOT" "$manifests_json" "$packages_json"
