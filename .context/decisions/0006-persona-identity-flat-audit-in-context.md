---
status: inferred
evidence: structural refactor 2026-07-27
supersedes: 0005
---

# 0006 — Flat persona identity in `.harness/`; audit in `.context/persona/`

## Decision

Persona identity files are flat: `.harness/persona/<persona>.md` (not nested `persona.md` subfolders). Audit history moves to `.context/persona/<persona>/audit.md` alongside memory and staging.

## Context

Nested `.harness/persona/<persona>/persona.md` was redundant naming. Audit is persona state like memory but was split across trees. Co-locating audit with memory under `.context/persona/<persona>/` keeps all mutable persona state in one place; `.harness/persona/` retains only lightweight identity for banner routing.

## Rejected alternatives

- **Move identity into `.context/persona/<persona>.md`** — rejected; identity stays in `.harness/` for tight coupling with skill routing rule.
- **Keep audit in `.harness/`** — rejected; audit is session history, not routing identity.

## Consequences

- Persona switch loads `.harness/persona/<persona>.md` + `.context/persona/<persona>/memory.md`.
- `/persona/persona-audit` writes to `.context/persona/<persona>/audit.md`.
- New personas need `.harness/persona/<persona>.md` and `.context/persona/<persona>/` (memory, memory-staging, audit stubs).
