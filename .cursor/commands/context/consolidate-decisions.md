# Consolidate Decisions

When this command runs, print exactly:

```text
*** USING COMMAND: context/consolidate-decisions ***
```

This command must **not** select, switch, or clear an active persona.

## Goal

Periodic maintenance for `.context/decisions/`: dedupe overlapping ADRs, identify stale or contradicted decisions, ensure INDEX.md stays accurate, propose supersession for reversals. **Present proposed changes for review — do not apply automatically.**

## Workflow

### 1. Inventory

- Read all `.context/decisions/[0-9][0-9][0-9][0-9]-*.md`.
- Read `.context/decisions/INDEX.md`.
- Cross-check `architecture.md` links point to valid ADRs.

### 2. Analyze

| Check | Action |
|-------|--------|
| Duplicate topics | Flag ADRs describing same decision; propose merge or supersession chain |
| INDEX drift | ADR file exists but missing/wrong INDEX row |
| Orphan INDEX rows | Row points to missing file |
| Contradictions | Two `confirmed` ADRs conflict → propose new superseding ADR |
| Stale inferred | ADR references removed components → propose confirm, supersede, or retire |
| Supersession chain | Verify `supersedes` / `superseded_by` metadata is consistent |

### 3. Immutability rules

- **`status: confirmed` ADRs:** never edit Decision/Context/Consequences body.
- Reversals → propose **new** ADR with `supersedes: NNNN`.
- Metadata-only updates (`superseded_by`) on old ADR are allowed when recording supersession.

### 4. Produce proposal (do not apply)

```markdown
## Consolidate decisions — proposal

### INDEX fixes
- Add row: 0004 — ...
- Fix summary for 0002: ...

### Duplicate / overlap
- 0001 and 0005 overlap on persona routing → recommend supersede or merge INDEX rows

### Proposed new ADRs (supersession)
- 0006 supersedes 0003 because: ...

### Stale inferred (review)
- 0002 — evidence none; recommend confirm or archive

### Architecture link fixes
- architecture.md line N: broken link to 000X

### No change
- ...
```

Include draft frontmatter and Decision one-liner for any proposed new ADR, but **do not create files** until user approves.

### 5. Optional apply (explicit approval only)

On explicit user approval (e.g. "apply context/consolidate-decisions"):

- Create approved superseding ADRs via same rules as `/context/new-adr`.
- Update INDEX.md rows (add/fix/remove pointers only — no full ADR paste).
- Patch `superseded_by` on superseded ADRs (metadata only).
- Fix broken links in `architecture.md` if listed in proposal.

### 6. Size / hygiene

- Keep INDEX.md as pointer table only.
- If >20 ADRs, propose tag grouping in INDEX or a `## Tags` section — not separate files.

## Guardrails

- Default mode is proposal only.
- Never rewrite confirmed ADR bodies.
- Never delete ADR files without explicit user request (prefer superseded_by metadata).
- Sequential numbering is append-only.

## Related

- `/context/new-adr` — create single ADR
- `/context/update-context architecture.md` — refresh architecture links after ADR changes
