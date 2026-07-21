#!/usr/bin/env bash
# Installs the agent-docs-scaffold skill into ~/.claude/skills (personal,
# default) or <project>/.claude/skills (with --project <path>).
#
# Works two ways:
#   - Run locally after `git clone` (uses the skills/ folder next to this script)
#   - Run via curl one-liner with no local clone (shallow-clones to a temp dir)
set -euo pipefail

REPO_URL="https://github.com/brokenlyre/agents_docs.git"
SKILL_NAME="agent-docs-scaffold"

PROJECT_PATH=""
while [[ $# -gt 0 ]]; do
  case "$1" in
    --project)
      PROJECT_PATH="${2:-}"
      shift 2
      ;;
    --project=*)
      PROJECT_PATH="${1#--project=}"
      shift
      ;;
    *)
      echo "Unknown argument: $1" >&2
      exit 1
      ;;
  esac
done

if [[ -n "$PROJECT_PATH" ]]; then
  TARGET_DIR="$PROJECT_PATH/.claude/skills"
else
  TARGET_DIR="$HOME/.claude/skills"
fi

# Resolve this script's directory (works even if sourced via a pipe, in which
# case BASH_SOURCE points at /dev/stdin and this check just falls through to
# the clone path below).
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]:-.}")" 2>/dev/null && pwd || true)"
SRC="${SCRIPT_DIR:-}/skills/$SKILL_NAME"

CLEANUP_DIR=""
if [[ ! -d "$SRC" ]]; then
  echo "Local skill source not found next to this script — fetching from $REPO_URL..."
  CLEANUP_DIR="$(mktemp -d)"
  git clone --depth 1 --quiet "$REPO_URL" "$CLEANUP_DIR"
  SRC="$CLEANUP_DIR/skills/$SKILL_NAME"
fi

if [[ ! -d "$SRC" ]]; then
  echo "Could not locate $SKILL_NAME source. Aborting." >&2
  [[ -n "$CLEANUP_DIR" ]] && rm -rf "$CLEANUP_DIR"
  exit 1
fi

mkdir -p "$TARGET_DIR"
rm -rf "${TARGET_DIR:?}/$SKILL_NAME"
cp -r "$SRC" "$TARGET_DIR/$SKILL_NAME"

[[ -n "$CLEANUP_DIR" ]] && rm -rf "$CLEANUP_DIR"

echo "Installed $SKILL_NAME to $TARGET_DIR/$SKILL_NAME"
if [[ -n "$PROJECT_PATH" ]]; then
  echo "This is a project-scoped install — commit it so teammates get it too:"
  echo "  cd \"$PROJECT_PATH\" && git add .claude/skills/$SKILL_NAME && git commit -m \"Add $SKILL_NAME skill\""
fi
echo "Open (or restart) a Claude Code session in the target repo and run /$SKILL_NAME to verify."
