#!/usr/bin/env bash
# Установка output style «Pohuy» для Claude Code одной командой:
#   curl -fsSL https://raw.githubusercontent.com/smixs/pohuy/main/install.sh | bash
#
# Ставит:
#   ~/.claude/output-styles/pohuy.md          — постоянный тон (output style)
#   ~/.claude/skills/pohuy/                   — скилл с полным словарём и сценами
#   ~/.claude/settings.json → "outputStyle": "Pohuy"
set -euo pipefail

CLAUDE_DIR="${CLAUDE_DIR:-$HOME/.claude}"
RAW="https://raw.githubusercontent.com/smixs/pohuy/main"

mkdir -p "$CLAUDE_DIR/output-styles" "$CLAUDE_DIR/skills/pohuy/references"

curl -fsSL "$RAW/output-styles/pohuy.md" -o "$CLAUDE_DIR/output-styles/pohuy.md"
curl -fsSL "$RAW/skills/pohuy/SKILL.md" -o "$CLAUDE_DIR/skills/pohuy/SKILL.md"
for f in slovar.md sceny.md ontologia.md; do
  curl -fsSL "$RAW/skills/pohuy/references/$f" -o "$CLAUDE_DIR/skills/pohuy/references/$f"
done

SETTINGS="$CLAUDE_DIR/settings.json"
if command -v python3 >/dev/null 2>&1; then
  python3 - "$SETTINGS" <<'PY'
import json, os, sys
path = sys.argv[1]
data = {}
if os.path.exists(path):
    with open(path) as f:
        data = json.load(f)
data["outputStyle"] = "Pohuy"
with open(path, "w") as f:
    json.dump(data, f, indent=2, ensure_ascii=False)
    f.write("\n")
PY
  echo "outputStyle: Pohuy прописан в $SETTINGS"
else
  echo "python3 не найден — включи стиль вручную командой /output-style Pohuy"
fi

echo "Готово. Перезапусти Claude Code."
