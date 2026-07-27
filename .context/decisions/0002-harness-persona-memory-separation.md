---
status: inferred
evidence: none — reconstructed from code
superseded_by: 0004
---

# 0002 — Persona identity and memory separated into `.harness/persona/`

## Decision

Persona identity (`persona.md`), live memory (`memory.md`), audit history (`audit.md`), and staging (`memory-staging.md`) live under `.harness/persona/<persona>/`, separate from Cursor skill definitions.

## Context

Skills define *what* to do; personas define *who* is acting and *how* they should behave over time. Splitting trees allows skill updates without rewriting persona state, and persona memory lifecycle (staging → promote → audit) independent of skill files.

## Rejected alternatives

- **Co-locate memory inside each skill folder** — rejected; one persona runs multiple skills; memory would fragment.
- **Single global memory file** — rejected; designer and developer need distinct behavioral learnings.

## Consequences

- Persona switch loads two files from `.harness/` on every new persona.
- `.context/memory/<persona>.md` mirrors context-system learnings but `.harness/` remains the live persona memory for skill execution today.

> **Superseded by [0004](0004-persona-memory-in-context.md)** — memory moved to `.context/`; see [0005](0005-persona-memory-under-context-persona.md) for current layout.
