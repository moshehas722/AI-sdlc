---
status: inferred
evidence: none — reconstructed from code
---

# 0001 — Persona skills live under `.cursor/skills/persona/`

## Decision

Only skills whose path matches `.cursor/skills/persona/<persona>/<skill>/` participate in persona selection and banner emission.

## Context

The harness needs a deterministic way to know when a skill belongs to a persona versus a generic Cursor skill. The `persona-management` rule scopes all routing logic to this path prefix.

## Rejected alternatives

- **Global persona on every skill** — rejected because non-persona skills (e.g. create-rule) should not trigger persona load.
- **Persona declared only in skill.yaml without path convention** — rejected; path segment provides a cheap, inspectable signal before parsing YAML.

## Consequences

- Adding a new persona requires `.cursor/skills/persona/<persona>/`, `.harness/persona/<persona>.md`, and `.context/persona/<persona>/` (memory.md, memory-staging.md, audit.md).
- Skills moved outside the persona tree silently stop selecting personas.
