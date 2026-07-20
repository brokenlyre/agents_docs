# agents_docs

A distributable Claude Code skill that scaffolds (or audits) a repository's
AI-agent documentation center: `AGENTS.md`, `CLAUDE.md`, and `docs/ai/`. The
pattern directs coding agents to persist durable project knowledge — vision,
architecture, standards, roadmap, decisions, open questions, history — in
the repo itself, not only in a single agent's local/session memory, so any
agent on any machine can pick up a project with full context.

See [`skills/agent-docs-scaffold/SKILL.md`](skills/agent-docs-scaffold/SKILL.md)
for the full methodology.

## Install

**Personal, all repos (recommended for your own machine):**

```sh
git clone <this-repo-url> agents_docs
cp -r agents_docs/skills/agent-docs-scaffold ~/.claude/skills/agent-docs-scaffold
```

**Project-scoped (to share with a team via git):**

```sh
cp -r agents_docs/skills/agent-docs-scaffold /path/to/your-repo/.claude/skills/agent-docs-scaffold
```

Commit the copied folder in the target repo so teammates' Claude Code
sessions pick it up automatically.

**To update:** re-copy the `agent-docs-scaffold` folder over the existing
one and re-install.

## Use

In a Claude Code session inside the target repo:

```
/agent-docs-scaffold
```

Or just describe what you want ("set up agent docs for this repo",
"audit this repo's docs/ai against the standard pattern") — the skill's
description will match and Claude will invoke it.

## What it produces

```
AGENTS.md                          tool-agnostic behavior guide (short, stable)
CLAUDE.md                          one-line import of AGENTS.md
docs/ai/
  README.md                        index + philosophy + "don't rely on local memory" clause
  product-vision.md
  architecture.md
  coding-standards.md
  roadmap.md
  decisions.md
  open-questions.md
  session-history.md
work/                               optional — for nontrivial multi-session/multi-agent work
  active/  archive/  templates/task-plan.md
```

Every generated file is filled with real project-specific content, not
placeholder text — the skill reads the repo (manifest, existing README,
structure) before writing anything, and only asks the user for what it
can't infer.
