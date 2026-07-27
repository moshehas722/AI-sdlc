---
status: inferred
verified_against: 2026-07-27
source: llm-synthesis
---

# Gotchas

Best-effort extraction at seed time. No `NOTE:` / `WARNING:` comments were found in source; items below are inferred from rule/command guardrails. **Confidence: medium–low** unless confirmed by a human.

## Persona routing

- **Missing persona files are hard failures.** If `persona.md` or `.context/memory/<persona>.md` is missing for a persona skill, the agent must stop — it will not fall back to the previous persona.
- **Model mismatch blocks the skill.** Non-`default` models in `skill.yaml` require user confirmation before banners or skill work run (e.g. designer `write-us` requests `gpt-5.2`).

## Memory and audit

- **`/persona/persona-retrospective` never writes to live memory.** Promotion requires `/persona/persona-promote-memory <persona> <staging-id>`.
- **Audit history is append-only.** Past session rows are not rewritten (except removing the seed row on first real audit).

## Context system

- **`business-overview.md` is intentionally empty.** Do not infer business purpose from code.
- **`dependencies.md` and `technology-stack.md` must come from the scanner.** Never LLM-guess versions.
- **`/context/retrospective` never auto-writes live memory or confirmed ADRs.** All output goes to pending staging or proposed diffs.

## Repository state

- **No git repository detected at seed time.** `verified_against` uses ISO dates instead of commit SHAs until git is initialized.
