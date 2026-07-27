# Consolidate Memory

When this command runs, print exactly:

```text
*** USING COMMAND: context/consolidate-memory ***
```

This command must **not** select, switch, or clear an active persona.

## Arguments

```text
/context/consolidate-memory <persona>
```

| Input | Behavior |
|-------|----------|
| `<persona>` | Persona name (e.g. `developer`, `designer`) |

If missing, stop and ask:

```text
/context/consolidate-memory <persona>
```

## Goal

Periodic maintenance for `.context/memory/<persona>.md` and `.context/memory/pending/<persona>.md`: dedupe overlapping entries, mark stale or contradicted items, keep files within a reasonable size. **Present proposed changes for review — do not apply automatically.**

## Workflow

### 1. Load sources

- Live: `.context/memory/<persona>.md`
- Pending: `.context/memory/pending/<persona>.md`

If live file missing, treat as empty scaffold.

### 2. Analyze

- **Duplicates:** same implication in pending and live, or repeated pending entries.
- **Contradictions:** pending insight conflicts with live bullet (note both; do not pick winner silently).
- **Stale:** entries referencing removed components, old conventions, or superseded ADRs.
- **Promotable:** pending entries with `Status: pending`, high confidence, no contradiction.

### 3. Produce proposal (do not apply)

Output a structured review document:

```markdown
## Consolidate memory — <persona>

### Proposed merges (pending → live)
| Pending Id | Target section | Proposed bullet | Action |
|------------|----------------|-----------------|--------|
| ctx-stg-... | Do | ... | merge |

### Proposed deduplications (live)
- Remove / merge bullet: "..." ← duplicate of "..."

### Proposed retirements (stale)
- Pending ctx-stg-...: reason stale

### Contradictions (needs human decision)
- Pending says X; live says Y

### No change
- Entries kept as-is with rationale
```

For each proposed merge into live memory, show the **exact bullet text** that would be added.

### 4. Optional apply (explicit approval only)

Apply changes **only** if the user explicitly approves in follow-up (e.g. "apply context/consolidate-memory developer"):

- Merge approved bullets into `.context/memory/<persona>.md` under correct sections.
- Set approved pending entries `Status: merged` with `- Merged: YYYY-MM-DD`.
- Rejected entries: `Status: rejected`.
- Never delete pending history; update status in place.

### 5. Size check

If live memory exceeds ~150 lines or 40 bullets, propose grouping or archiving older merged pending entries to a `## Archive` section at bottom of pending file.

## Guardrails

- Default mode is proposal only.
- Do not drop pending entries without marking status.
- Preserve Id fields for traceability.

## Related

- `/context/retrospective` — produces pending entries
- `/persona/persona-promote-memory` — promote pending → live memory
