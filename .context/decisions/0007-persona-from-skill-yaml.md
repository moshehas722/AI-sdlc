---
status: inferred
evidence: user request 2026-07-28
supersedes: partial — persona identity resolution in 0001
---

# 0007 — Persona selection from `skill.yaml` only

## Decision

For skills under `.cursor/skills/persona/`, the `persona` field in `skill.yaml` is the **sole authority** for persona selection and routing. Path segments under the persona skill tree are not used to infer or validate persona.

## Context

Path-based inference duplicated information already declared in `skill.yaml` and required keeping directory names in sync with YAML. A single source of truth in `skill.yaml` simplifies skill moves and reorganization without changing runtime behavior.

Scope gating from [0001](0001-persona-skills-under-cursor-tree.md) is unchanged: only skills under `.cursor/skills/persona/` participate in persona selection.

## Rejected alternatives

- **Path segment as primary with yaml validation** — previous approach; path inferred persona and yaml `persona` had to match.
- **Global persona on every skill** — unchanged from 0001; non-persona-tree skills still excluded.

## Consequences

- `skill.yaml` must include a non-empty `persona` field; missing or empty values are configuration errors.
- Directory layout (e.g. `<persona>/<skill>/`) remains a useful convention but is organizational only.
- Persona switch loads `.harness/persona/<persona>.md` and `.context/persona/<persona>/memory.md` using the yaml-declared name.
