# Retrospective (Context)

When this command runs, print exactly:

```text
*** USING COMMAND: context/retrospective ***
```

This command must **not** select, switch, or clear an active persona.

> **Note:** This is the **project context** retrospective (repo facts + persona behavior). For persona-performance feedback only, `/persona/persona-retrospective` is equivalent — both write to `.context/memory/pending/<persona>.md`.

Any text after `/context/retrospective` is extra focus (e.g. a persona name or topic).

## Goal

Analyze the current session's conversation, artifacts produced/revised, and explicit user corrections. Emit structured insights routed by category. **Everything requires human approval before promotion to live files.**

## Workflow

### 1. Gather session evidence

- Full chat history in context.
- Files created or modified this session.
- Explicit user corrections, preferences, and rejections.
- Agent transcripts if chat history is incomplete.

### 2. Classify each insight

Tag every insight with:

| Field | Values |
|-------|--------|
| `target_persona` | e.g. `developer`, `designer`, or `general` |
| `category` | See routing table below |
| `confidence` | `high` \| `medium` \| `low` |
| `evidence` | Quote or reference to user statement / artifact |

### 3. Route outputs (never auto-apply)

| Category | Destination | Action |
|----------|-------------|--------|
| Persona-general behavior | `.context/memory/pending/<persona>.md` | **Append** dated entry |
| Repo-specific + decision-shaped | Draft new ADR file **or** propose via `/context/new-adr` | `status: inferred` unless user explicitly confirmed reasoning → `confirmed` |
| Repo-specific + non-decision | `gotchas.md` or `conventions.md` | **Present as diff**; do not write |
| Repo fact (architecture, inventory) | Relevant top-level file | **Present as diff**; do not write |

**Never write to:**

- `.context/memory/<persona>.md` (live memory — promote via `/persona/persona-promote-memory`)
- Existing ADRs with `status: confirmed`

### 4. Pending memory entry shape

Append to `.context/memory/pending/<persona>.md` (create if missing):

```markdown
## Retrospective YYYY-MM-DD

- Id: ctx-stg-YYYYMMDD-NN
- Category: persona-behavior
- Insight: ...
- Evidence: ...
- Confidence: high | medium | low
- Status: pending
```

Sequence `NN` per persona per day starting at `01`.

### 5. Draft ADR (when decision-shaped)

If insight is architectural/strategic:

- Either scaffold with `/context/new-adr` content inline (do not run interactively unless needed)
- Or present draft markdown for user review before file creation
- Set `evidence:` to conversation date or commit if available

### 6. Proposed diffs (non-decision repo facts)

For `gotchas.md`, `conventions.md`, `architecture.md`, etc.:

- Show unified diff or before/after snippet
- Label: **Proposed — not applied**
- Ask user to approve; if approved, user may run `/context/update-context <file>` or apply manually

### 7. Report

```markdown
## Retrospective summary

### Pending memory (appended)
- <persona>: ctx-stg-... — <one-line insight>

### Draft ADRs (not filed / filed as inferred)
- ...

### Proposed diffs (awaiting approval)
- gotchas.md — ...
- conventions.md — ...

### Skipped (insufficient evidence)
- ...
```

## Guardrails

- Do not invent insights the user did not imply or state.
- Do not auto-merge pending → live memory.
- Do not auto-apply diffs.
- Do not edit confirmed ADRs in place.

## Related commands

- `/context/consolidate-memory <persona>` — dedupe pending → propose live merge
- `/persona/persona-promote-memory` — promote pending → live memory
