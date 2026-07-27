---
status: inferred
evidence: structural refactor 2026-07-27
supersedes: 0004
superseded_by: 0006
---

# 0005 — Persona memory under `.context/persona/<persona>/`

## Decision

Live persona memory lives at `.context/persona/<persona>/memory.md`; staging at `.context/persona/<persona>/memory-staging.md`. Co-locate per persona under one folder instead of flat `memory/` + `memory/pending/` trees.

## Context

The flat `.context/memory/<persona>.md` and `.context/memory/pending/<persona>.md` layout split one persona's artifacts across two directory conventions. Grouping under `.context/persona/<persona>/` mirrors `.harness/persona/<persona>/` identity layout and keeps live + staging files adjacent.

## Rejected alternatives

- **Keep flat `memory/` + `pending/`** — rejected; harder to discover all files for one persona.
- **Move persona.md from `.harness/` into `.context/persona/`** — rejected for now; identity banners remain in `.harness/` per 0004.

## Consequences

- Persona switch loads `.harness/persona/<persona>/persona.md` + `.context/persona/<persona>/memory.md`.
- All persona memory commands read/write `.context/persona/<persona>/memory.md` and `memory-staging.md`.
- New personas require `.context/persona/<persona>/` with both files stubbed.

> **Superseded by [0006](0006-persona-identity-flat-audit-in-context.md)** — identity flattened to `.harness/persona/<persona>.md`; audit moved to `.context/persona/<persona>/`.
