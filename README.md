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

Run one command. It fetches the skill and asks where to put it — no need
to clone the repo first.

**macOS/Linux/WSL/Git Bash:**

```sh
curl -fsSL https://raw.githubusercontent.com/brokenlyre/agents_docs/master/install.sh | bash
```

**Windows PowerShell:**

```powershell
irm https://raw.githubusercontent.com/brokenlyre/agents_docs/master/install.ps1 | iex
```

It'll ask:

```
1) Personal — available in every repo on this machine (default)
2) Project  — installed into one repo's .claude/skills, for you to commit and share
```

- **Personal** copies to `~/.claude/skills/` — the skill works in every
  repo you open on this machine, for you only.
- **Project** copies to `<path-you-give-it>/.claude/skills/` — only that
  repo gets it, but it's then a normal tracked file: commit it and anyone
  who clones the repo gets the skill too. The script prints the `git add`/
  `commit` command to do that.

For scripted/non-interactive use, skip the prompt with a flag:

```sh
bash install.sh --personal
bash install.sh --project /path/to/your-repo
```
```powershell
.\install.ps1 -Personal
.\install.ps1 -ProjectPath C:\path\to\your-repo
```

(Piped one-liners can't take flags — download the script first if you want
non-interactive project install without cloning: `curl -fsSL .../install.sh
-o install.sh && bash install.sh --project <path>`.)

**If you'd rather clone first** (e.g. to inspect the skill before
installing, or you'll be offline afterward), the same script works run
locally — it uses the cloned copy instead of re-fetching:

```sh
git clone https://github.com/brokenlyre/agents_docs.git
cd agents_docs
./install.sh          # or ./install.ps1 on Windows — same prompt
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
