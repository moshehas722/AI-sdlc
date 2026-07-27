---
status: inferred
verified_against: 2026-07-27
source: llm-synthesis
---

# Architecture (current state)

Agentic SDLC harness: Cursor skills invoke persona-bound workflows; persona identity lives in `.harness/persona/`, persona memory in `.context/memory/`. No application runtime, database, or HTTP API — configuration and markdown artifacts only.

## High-level layout

```
.cursor/
├── rules/          → always-on agent policies (persona routing, context access)
├── skills/persona/ → persona-bound skill definitions + contracts
└── commands/       → slash-command workflows
    ├── persona/    → persona lifecycle (audit, retrospective, promote)
    └── context/    → project context lifecycle (seed, update, ADR)

.harness/persona/   → persona identity + audit (per persona)

.context/           → repo knowledge manifest + persona memory
    └── memory/     → live + pending persona behavioral learnings
```

## Component interactions

| From | To | Interaction |
|------|-----|-------------|
| User | `.cursor/skills/persona/<persona>/<skill>/` | Invokes a skill; triggers persona selection per [0001](decisions/0001-persona-skills-under-cursor-tree.md) |
| `persona-management` rule | `.harness/persona/<persona>/persona.md` + `.context/memory/<persona>.md` | Loads identity + memory on persona switch |
| `skill.yaml` | Task subagent (when `run_mode: subagent`) | Delegates heavy skills per [0003](decisions/0003-subagent-run-mode-for-heavy-skills.md) |
| Persona commands | `.context/memory/` + `.harness/persona/` | Retrospective → pending; promote → live memory; audit → audit.md |
| Context commands | `.context/` | Seed, update, ADR, retrospective, consolidate workflows |

## Persona selection flow

1. Skill path under `.cursor/skills/persona/<persona>/` determines persona.
2. Rule reads `skill.yaml` (model, run_mode, I/O contract).
3. On persona switch: emit banner block, load `.harness/persona/<persona>/persona.md` + `.context/memory/<persona>.md`.
4. Execute skill inline or via subagent per `run_mode`.

## Data boundaries

- **Repo facts** → `.context/` top-level files (architecture, conventions, ADRs, dependencies).
- **Persona behavior (live)** → `.context/memory/<persona>.md` — see [0004](decisions/0004-persona-memory-in-context.md).
- **Persona behavior (staging)** → `.context/memory/pending/<persona>.md` — never auto-promoted.
- **Persona identity + audit** → `.harness/persona/<persona>/persona.md`, `audit.md`.

## Active personas

| Persona | Skills | Run mode |
|---------|--------|----------|
| developer | fix-bug (inline), review-code (subagent) | mixed |
| designer | write-us (subagent) | subagent |

Persona memory is stored separately from skills and identity — see [0004](decisions/0004-persona-memory-in-context.md).
