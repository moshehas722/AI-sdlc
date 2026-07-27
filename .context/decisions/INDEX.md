# Architecture Decision Records — Index

Pointer table only. Full content lives in numbered files alongside this index.

| # | Title | Status | Tags | Summary |
|---|-------|--------|------|---------|
| [0001](0001-persona-skills-under-cursor-tree.md) | Persona skills live under `.cursor/skills/persona/` | inferred | persona, skills, routing | Persona selection applies only to skills under the persona skill tree |
| [0002](0002-harness-persona-memory-separation.md) | Persona identity and memory separated into `.harness/persona/` | superseded | persona, memory, harness | Superseded by 0004 — memory moved to `.context/memory/` |
| [0003](0003-subagent-run-mode-for-heavy-skills.md) | Heavy skills use `run_mode: subagent` | inferred | skills, subagent, performance | Review and user-story skills delegate to a subagent; fix-bug stays inline |
| [0004](0004-persona-memory-in-context.md) | Persona memory lives in `.context/memory/` | inferred | persona, memory, context | Single canonical location for live memory and pending staging |

## Adding ADRs

Use `/context/new-adr "<title>"` to scaffold the next sequential file and append a row here.

## Immutability

ADRs with `status: confirmed` are immutable. To reverse a decision, create a new ADR referencing `supersedes: NNNN`.
