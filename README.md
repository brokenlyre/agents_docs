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

- **`~/.claude/skills/`** (personal, default) — makes it available in
  *every* repo you open on this machine, for you only.
- **`<your-repo>/.claude/skills/`** (project) — makes it available to
  anyone who clones that specific repo, once the folder is committed.

An install script handles copying the files to the right place — you don't
need to clone the repo yourself first.

**Personal install (macOS/Linux/WSL/Git Bash):**

```sh
curl -fsSL https://raw.githubusercontent.com/brokenlyre/agents_docs/master/install.sh | bash
```

**Personal install (Windows PowerShell):**

```powershell
irm https://raw.githubusercontent.com/brokenlyre/agents_docs/master/install.ps1 | iex
```

**Project install** — pass the repo path so it lands in that project's
`.claude/skills/` instead of your personal one. Since curl-into-`iex` can't
take arguments, download the script first, then run it with a flag:

```sh
curl -fsSL https://raw.githubusercontent.com/brokenlyre/agents_docs/master/install.sh -o /tmp/install.sh
bash /tmp/install.sh --project /path/to/your-repo
```

```powershell
irm https://raw.githubusercontent.com/brokenlyre/agents_docs/master/install.ps1 -OutFile $env:TEMP\install.ps1
& $env:TEMP\install.ps1 -ProjectPath C:\path\to\your-repo
```

The script prints a `git add`/`commit` reminder for project installs, since
that's what actually shares it with teammates — the copy alone is just a
local working-tree change.

**If you'd rather clone first** (e.g. to inspect the skill before
installing, or you're offline afterward), the same script works run
locally — it'll use the cloned copy instead of re-fetching:

```sh
git clone https://github.com/brokenlyre/agents_docs.git
cd agents_docs
./install.sh                      # personal install
./install.ps1                     # personal install (Windows)
./install.sh --project /path/to/your-repo
./install.ps1 -ProjectPath C:\path\to\your-repo
```

**Verify it's picked up.** Open (or restart) a Claude Code session in the
target repo and run `/agent-docs-scaffold` — if it's installed, Claude runs
the skill; if not, you'll get an unrecognized-command response. You can
also just ask Claude "what skills are available?" and check the name
appears in the list.

**To update later:** re-run the same install command — it always
overwrites the installed copy with the latest version.

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
