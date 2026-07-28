# Architecture Decision Records — Index

Pointer table only. Full content lives in numbered files alongside this index.

| # | Title | Status | Tags | Summary |
|---|-------|--------|------|---------|
| [0001](0001-persona-skills-under-cursor-tree.md) | Persona skills live under `.cursor/skills/persona/` | inferred | persona, skills, routing | Persona selection applies only to skills under the persona skill tree |
| [0007](0007-persona-from-skill-yaml.md) | Persona selection from `skill.yaml` only | inferred | persona, skills, routing | `skill.yaml` `persona` is sole authority; path segments are organizational |
| [0002](0002-harness-persona-memory-separation.md) | Persona identity and memory separated into `.harness/persona/` | superseded | persona, memory, harness | Superseded by 0004 — memory moved to `.context/memory/` |
| [0003](0003-subagent-run-mode-for-heavy-skills.md) | Heavy skills use `run_mode: subagent` | inferred | skills, subagent, performance | Review and user-story skills delegate to a subagent; fix-bug stays inline |
| [0004](0004-persona-memory-in-context.md) | Persona memory lives in `.context/memory/` | superseded | persona, memory, context | Superseded by 0005 — relocated to `.context/persona/<persona>/` |
| [0005](0005-persona-memory-under-context-persona.md) | Persona memory under `.context/persona/<persona>/` | superseded | persona, memory, context | Superseded by 0006 — audit joined; identity flattened |
| [0006](0006-persona-identity-flat-audit-in-context.md) | Flat identity in `.harness/`; audit in `.context/persona/` | inferred | persona, harness, context | Identity at `.harness/persona/<persona>.md`; audit with memory |

## Adding ADRs

Use `/context/new-adr "<title>"` to scaffold the next sequential file and append a row here.

## Immutability

ADRs with `status: confirmed` are immutable. To reverse a decision, create a new ADR referencing `supersedes: NNNN`.
