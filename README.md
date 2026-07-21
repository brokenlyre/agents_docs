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

There are two install locations depending on who should get the skill:

- **`~/.claude/skills/`** (personal) — makes it available in *every* repo
  you open on this machine, for you only.
- **`<your-repo>/.claude/skills/`** (project) — makes it available to
  anyone who clones that specific repo, once the folder is committed.

Either way, the steps are: clone this repo somewhere, then copy the
`agent-docs-scaffold` folder into one of those two locations. Cloning
itself doesn't install anything — Claude Code only looks inside
`~/.claude/skills/` and `<repo>/.claude/skills/`, so the copy step is what
actually matters.

**1. Clone this repo** (anywhere — it's just a source to copy from, e.g. next to your other repos):

```sh
git clone https://github.com/brokenlyre/agents_docs.git
```

**2a. Personal install** — available in every repo on this machine:

macOS/Linux:
```sh
mkdir -p ~/.claude/skills
cp -r agents_docs/skills/agent-docs-scaffold ~/.claude/skills/agent-docs-scaffold
```

Windows (PowerShell):
```powershell
New-Item -ItemType Directory -Force -Path "$env:USERPROFILE\.claude\skills" | Out-Null
Copy-Item -Recurse -Force agents_docs\skills\agent-docs-scaffold "$env:USERPROFILE\.claude\skills\agent-docs-scaffold"
```

**2b. Project install** — available to anyone who clones that repo, once you commit the copied folder:

```sh
mkdir -p /path/to/your-repo/.claude/skills
cp -r agents_docs/skills/agent-docs-scaffold /path/to/your-repo/.claude/skills/agent-docs-scaffold
cd /path/to/your-repo
git add .claude/skills/agent-docs-scaffold
git commit -m "Add agent-docs-scaffold skill"
```

**3. Verify it's picked up.** Open (or restart) a Claude Code session in
the target repo and run `/agent-docs-scaffold` — if it's installed, Claude
runs the skill; if not, you'll get an unrecognized-command response. You
can also just ask Claude "what skills are available?" and check the name
appears in the list.

**To update later:** pull the latest changes in your `agents_docs` clone
(`git pull`), then re-run step 2a/2b to overwrite the installed copy —
there's no separate updater.

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
