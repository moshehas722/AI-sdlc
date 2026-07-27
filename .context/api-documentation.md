---
status: inferred
verified_against: 2026-07-27
source: llm-synthesis
---

# API Documentation

No OpenAPI specs, GraphQL schemas, or HTTP route definitions were found in this repository.

## External interfaces

This repo exposes **agent-facing interfaces** only (not HTTP APIs):

| Interface | Entry | Contract |
|-----------|-------|----------|
| Persona skills | `.cursor/skills/persona/<persona>/<skill>/SKILL.md` | Workflow in SKILL.md; I/O in `skill.yaml` |
| Slash commands | `.cursor/commands/*.md` | Markdown workflow definitions |
| Context commands | `.cursor/commands/context/` | See `.context/TOC.md` |

## Skill I/O contracts (from skill.yaml)

### developer / fix-bug

- **Input (required):** `problem_statement`
- **Input (optional):** `reproduction_steps`, `logs`, `failing_tests`, `suspected_files`
- **Output:** `root_cause`, `code_changes`, `validation_results`, `remaining_risk`

### developer / review-code

- **Input (required):** `change_scope`
- **Input (optional):** `diff`, `pr_url`, `focus_areas`, `acceptance_criteria`
- **Output:** `findings`, `severity_summary`, `validation_notes`, `remaining_uncertainty`

### designer / write-us

- **Input (required):** `feature_or_problem`
- **Input (optional):** `persona_or_actor`, `constraints`, `acceptance_hints`, `priority`
- **Output:** `user_story`, `acceptance_criteria`, `notes`

If HTTP/API routes are added later, regenerate with `/context/update-context api-documentation.md`.
