---
status: inferred
verified_against: 2026-07-27
source: llm-synthesis
---

# Architecture (current state)

Agentic SDLC harness: Cursor skills invoke persona-bound workflows; persona identity in flat `.harness/persona/*.md`; memory, staging, and audit in `.context/persona/<persona>/`. No application runtime, database, or HTTP API — configuration and markdown artifacts only.

## High-level layout

```
.cursor/
├── rules/          → harness.mdc loader (context + persona instructions)
├── skills/persona/ → persona-bound skill definitions + contracts
└── commands/       → slash-command workflows
    ├── persona/    → persona lifecycle (audit, retrospective, promote)
    └── context/    → project context lifecycle (seed, update, ADR)

.harness/
├── rules/          → context-instructions.mdc, persona-instructions.mdc
└── persona/        → persona identity files (<persona>.md)

.context/           → repo knowledge manifest + persona state
    └── persona/    → per-persona memory, staging, audit
```

## Component interactions

| From | To | Interaction |
|------|-----|-------------|
| User | `.cursor/skills/persona/<persona>/<skill>/` | Invokes a skill; triggers persona selection per [0001](decisions/0001-persona-skills-under-cursor-tree.md) |
| `persona-instructions` rule | `.harness/persona/<persona>.md` + `.context/persona/<persona>/memory.md` | Loads identity + memory on persona switch |
| `skill.yaml` | Task subagent (when `run_mode: subagent`) | Delegates heavy skills per [0003](decisions/0003-subagent-run-mode-for-heavy-skills.md) |
| Persona commands | `.context/persona/` + `.harness/persona/` | Retrospective → staging; promote → memory; audit → audit.md |
| Context commands | `.context/` | Seed, update, ADR, retrospective, consolidate workflows |

## Persona selection flow

1. Skill path under `.cursor/skills/persona/` gates persona selection (non-persona skills are excluded).
2. Rule reads `skill.yaml`; `persona` field is the sole authority for which persona to load.
3. On persona switch: emit banner block, load `.harness/persona/<persona>.md` + `.context/persona/<persona>/memory.md`.
4. Execute skill inline or via subagent per `run_mode`.

## Data boundaries

- **Repo facts** → `.context/` top-level files (architecture, conventions, ADRs, dependencies).
- **Persona behavior (live)** → `.context/persona/<persona>/memory.md` — see [0006](decisions/0006-persona-identity-flat-audit-in-context.md).
- **Persona behavior (staging)** → `.context/persona/<persona>/memory-staging.md` — never auto-promoted.
- **Persona audit** → `.context/persona/<persona>/audit.md`.
- **Persona identity** → `.harness/persona/<persona>.md`.

## Active personas

| Persona | Skills | Run mode |
|---------|--------|----------|
| developer | fix-bug (inline), review-code (subagent) | mixed |
| designer | write-us (subagent) | subagent |

Persona state is split: identity in `.harness/`, memory/audit in `.context/persona/` — see [0006](decisions/0006-persona-identity-flat-audit-in-context.md).
