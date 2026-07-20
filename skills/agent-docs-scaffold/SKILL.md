---
name: agent-docs-scaffold
description: Scaffold or audit a repository's AI-agent documentation center (AGENTS.md, CLAUDE.md, docs/ai/) so coding agents persist durable project knowledge in the repo instead of local/session memory. Use when initializing a new repo for AI-agent collaboration, onboarding a repo to this pattern, or auditing/upgrading an existing repo's agent docs against it.
---

# Agent Docs Scaffold

Gives a repository a durable, git-tracked "documentation center" that coding
agents read at the start of a session and write to as they learn things,
instead of relying on per-machine agent memory (Claude Code auto-memory, a
long chat transcript, etc.) which is invisible to any other session, machine,
or agent working on the same repo.

This skill is the **methodology**, not just a file dump. Read it fully before
writing anything — the value is in *how* the scaffold is filled in and kept
alive, not in the existence of the files.

## Core principle

> Anything durable enough to matter next session, on another machine, or to
> another agent belongs in the repo — not only in an agent's local memory.

Local memory (Claude Code's auto-memory, a chat transcript, an IDE's session
state) is real and useful, but it is scoped to one user on one machine. A
teammate's agent, a cloud sandbox, or you six months from now cannot see it.
The docs/ai/ center is the shared substrate everyone reads from and writes to.

## When to use this skill

- A repo has no `AGENTS.md` / `docs/ai/` yet and the user wants agents to
  collaborate on it long-term (not a one-off script or throwaway prototype).
- A repo has partial agent docs (e.g. just a `CLAUDE.md` with ad hoc notes)
  and needs to be brought onto the standard pattern.
- Auditing an existing `docs/ai/` for drift: stale entries, duplicated facts,
  missing index rows, files that should exist but don't.

Do not use this for tiny/disposable repos (a scratch script, a one-file demo)
— the overhead isn't worth it. If unsure, ask.

## The two-layer architecture

1. **`AGENTS.md`** (root, tool-agnostic) + **`CLAUDE.md`** (root, one line
   importing `AGENTS.md`, for tools that specifically look for that filename).
   Short and **behavioral** — how to act in this repo. It rarely changes.
   Any other agent-specific entrypoint file (`.cursorrules`, `GEMINI.md`, a
   Codex config) should follow the same one-line-import pattern so behavior
   is defined once.
2. **`docs/ai/`** — durable, present-tense **project knowledge**: vision,
   architecture, standards, roadmap, decisions, open questions, history.
   This is what grows and changes as the project evolves. `AGENTS.md` points
   here; it does not duplicate this content.

Keep the split strict: behavior rules (how to act) go in `AGENTS.md`. Project
facts (what is true about this project) go in `docs/ai/`. If you catch
yourself adding a fact to `AGENTS.md`, it belongs in `docs/ai/` instead.

## Step-by-step process

### 1. Establish target and mode

Confirm the target directory (usually the current repo root). Check what
already exists:

```
README.md, AGENTS.md, CLAUDE.md, docs/ai/**
```

- **Nothing exists** → full scaffold (Step 2 onward).
- **Partial** (e.g. `docs/ai/` exists but thin, or `AGENTS.md` exists but
  doesn't point to `docs/ai/`) → audit mode: report what's missing/drifted,
  then fill gaps without clobbering content that's already good. Never
  silently overwrite a file with real content in it — show a diff or ask.
- **Full and healthy** → nothing to do; report that it already conforms.

### 2. Gather project facts before writing anything

Don't ask the user questions you can answer yourself. Read what's already
there first:

- `package.json` / `pyproject.toml` / `Cargo.toml` / etc. for name,
  description, dependencies, scripts (lint/typecheck/test/build commands).
- Existing `README.md` for purpose, stack, setup instructions.
- Directory structure for architecture (framework, monorepo layout, major
  components).
- Git remote / `.github/` for repo identity and CI.

Only ask the user for what genuinely can't be inferred: product vision and
target users, non-obvious architectural decisions already made, whether a
work-log module is warranted (Step 5).

### 3. Write the root files

Use `templates/AGENTS.md.template` and `templates/CLAUDE.md.template`. Fill
`{{PROJECT_NAME}}` and any bracketed placeholders from what you learned in
Step 2. If `AGENTS.md` already exists with real project-specific rules,
merge — keep the existing rules, add the missing structural pieces (the
pointer to `docs/ai/`, the memory clause, the workflow expectations) rather
than replacing the file wholesale.

If the repo has a root `README.md` already, add a short pointer near the top
or in a "For AI agents" section linking to `AGENTS.md` — don't duplicate
`AGENTS.md`'s content into it. If there's no `README.md` at all, that's a
human-facing document outside this skill's scope; mention it to the user
rather than inventing one from nothing.

### 4. Write `docs/ai/`

Create `docs/ai/README.md` from `templates/docs-ai/README.md.template` —
this is the index. Then create the core knowledge files, each from its
template in `templates/docs-ai/`:

| File | Holds |
|---|---|
| `product-vision.md` | Mission, target users, guiding principles |
| `architecture.md` | Stack, structure, major components, data flow, integrations, deployment |
| `coding-standards.md` | Concrete conventions, gotchas, exact lint/test/build commands |
| `roadmap.md` | Shipped / in progress / next, in priority order |
| `decisions.md` | Significant decisions with reasons, alternatives, tradeoffs |
| `open-questions.md` | Unresolved questions and assumptions — deliberately unanswered |
| `session-history.md` | Concise chronological milestone log (the *only* file that accumulates rather than staying present-tense) |

Fill each with real content from Step 2 — don't leave templated placeholder
text sitting in a file you're marking as scaffolded. A file with nothing yet
to say should contain a one-line "nothing recorded yet" note, not fake
content invented to fill space.

Add optional files only when they earn their place (don't scaffold empty
ones speculatively):

- `design-principles.md` — visual/UX identity, if the project has one.
- `glossary.md` — once domain terms start recurring across docs.
- `feature-backlog.md` — once there's a real backlog distinct from the
  roadmap's near-term priorities.
- `implementation-blueprints.md` — once a feature gets scoped in detail
  before being built (full spec: objective, UX/UI, acceptance criteria, edge
  cases). Give it a Lifecycle note: once shipped, summarize into
  `session-history.md` and delete the spec — don't leave it stale.

Update `docs/ai/README.md`'s index table whenever a file is added or removed.

### 5. Offer the optional work-log module

For repos where nontrivial, multi-session, or multi-agent work is expected,
offer `templates/docs-ai-optional/work-log/`: a `work/active/` and
`work/archive/` convention for task plans (objective, scope, out-of-scope,
files expected to change, assumptions, risks, validation plan, progress
checklist, handoff notes) on top of ad hoc chat. This earns its keep on
larger projects; skip it for small/solo repos — `roadmap.md` and
`decisions.md` are enough there. Ask the user if unsure rather than assuming.

### 6. Validate before reporting done

- Every link in `docs/ai/README.md`'s table resolves to a real file.
- No leftover `{{PLACEHOLDER}}` tokens in any written file.
- `AGENTS.md` actually contains the memory clause (Step 7) and points to
  `docs/ai/README.md`.
- If `docs/ai/coding-standards.md` names lint/test/build commands, verify
  they match what's actually in `package.json`/equivalent, not guessed.

### 7. The memory clause — non-negotiable

Every `AGENTS.md` this skill produces must carry a version of this rule, and
every `docs/ai/README.md` must carry the matching "Relationship to Local
Memory" section (both are already in the templates — don't strip them):

> When you learn or decide something durable, update the relevant file in
> `docs/ai/` directly, not just local memory. Local memory (e.g. Claude
> Code's auto-memory) is per-machine and invisible to other sessions,
> machines, or agents; `docs/ai/` is what keeps everyone in sync.

This is the entire point of the skill — don't let it get diluted into "maybe
also write docs sometime."

## Maintenance philosophy (carry into the generated docs, not just this skill)

- **One home per fact.** If you're about to write something documented
  elsewhere, update the existing entry — don't duplicate it.
- **Update, don't recreate.** Edit the relevant file in place; don't spawn a
  new file for something that fits an existing one.
- **Read only what's relevant.** The `docs/ai/README.md` index maps task
  types to files so an agent doesn't have to load the whole directory every
  session.
- **Knowledge base, not changelog.** Everything except `session-history.md`
  should read as present-tense truth. Git history is the changelog — don't
  duplicate it inside the docs (e.g. no dated "Changelog" sections).

## Anti-patterns to avoid

- Scaffolding all optional files "just in case" — empty aspirational docs rot
  and mislead the next reader.
- Writing project facts into `AGENTS.md` instead of `docs/ai/` because it was
  faster in the moment — breaks the behavior/knowledge split.
- Treating this as a one-time setup task — the value only compounds if
  agents actually keep `docs/ai/` updated as they work. Say so explicitly
  when reporting completion: this is a habit to sustain, not a checkbox.
- Copying another repo's `docs/ai/` content wholesale as a starting point —
  every field must reflect *this* project, not a template repo's example
  values.
