---
status: inferred
evidence: none — reconstructed from code
---

# 0003 — Heavy skills use `run_mode: subagent`

## Decision

Skills that produce large artifacts or deep analysis (`review-code`, `write-us`) set `run_mode: subagent`; lighter interactive skills (`fix-bug`) use `run_mode: inline`.

## Context

Subagent delegation keeps the parent response focused on persona banners and artifact rendering while isolating long-running review or authoring work. Parent must not perform substantive subagent skill work inline.

## Rejected alternatives

- **All skills inline** — rejected for token/latency cost on review and story authoring.
- **All skills subagent** — rejected for fix-bug where tight interactive debugging loops are preferable.

## Consequences

- Parent must launch exactly one Task subagent per subagent skill invocation.
- Subagent must not emit persona banner blocks (owned by parent).
