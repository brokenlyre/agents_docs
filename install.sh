#!/usr/bin/env bash
# Installs the agent-docs-scaffold skill into ~/.claude/skills (personal)
# or <project>/.claude/skills (project-scoped).
#
# With no arguments and an interactive terminal, prompts for which. Pass
# --project <path> (or --personal) to skip the prompt, e.g. for scripting.
#
# Works two ways:
#   - Run locally after `git clone` (uses the skills/ folder next to this script)
#   - Run via curl one-liner with no local clone (shallow-clones to a temp dir)
set -euo pipefail

REPO_URL="https://github.com/brokenlyre/agents_docs.git"
SKILL_NAME="agent-docs-scaffold"

PROJECT_PATH=""
MODE=""  # "personal" | "project" | "" (undecided)
while [[ $# -gt 0 ]]; do
  case "$1" in
    --project)
      PROJECT_PATH="${2:-}"
      MODE="project"
      shift 2
      ;;
    --project=*)
      PROJECT_PATH="${1#--project=}"
      MODE="project"
      shift
      ;;
    --personal)
      MODE="personal"
      shift
      ;;
    *)
      echo "Unknown argument: $1" >&2
      exit 1
      ;;
  esac
done

# No mode chosen via flags — ask, if we have a real terminal to ask on.
# (curl ... | bash pipes stdin from curl, not the keyboard, so read from
# /dev/tty explicitly; if there's no tty at all — e.g. CI — default to
# personal rather than hanging.)
if [[ -z "$MODE" ]]; then
  # Probe /dev/tty in a subshell so a failed open can't abort or leak a
  # redirection into the main shell (exec's redirections persist on success).
  if ( : < /dev/tty ) 2>/dev/null; then
    echo "Install agent-docs-scaffold:"
    echo "  1) Personal — available in every repo on this machine (default)"
    echo "  2) Project  — installed into one repo's .claude/skills, for you to commit and share"
    exec 3</dev/tty
    read -r -u 3 -p "Choose [1/2]: " CHOICE
    if [[ "$CHOICE" == "2" ]]; then
      read -r -u 3 -p "Project path: " PROJECT_PATH
      MODE="project"
    else
      MODE="personal"
    fi
    exec 3<&-
  else
    echo "No interactive terminal detected — defaulting to personal install."
    echo "(Pass --project <path> or --personal to skip this in the future.)"
    MODE="personal"
  fi
fi

if [[ "$MODE" == "project" ]]; then
  if [[ -z "$PROJECT_PATH" ]]; then
    echo "Project install requires a path (--project <path>)." >&2
    exit 1
  fi
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
