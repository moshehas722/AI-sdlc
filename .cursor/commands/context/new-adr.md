# New ADR

When this command runs, print exactly:

```text
*** USING COMMAND: context/new-adr ***
```

This command must **not** select, switch, or clear an active persona.

## Arguments

```text
/context/new-adr "<title>"
```

| Input | Behavior |
|-------|----------|
| `"<title>"` | Short decision title (required) |
| Additional text in chat | Optional pre-fill for Decision / Context / Consequences sections |

If title is missing, stop and ask:

```text
/context/new-adr "<title>"
```

Example: `/context/new-adr "Store context memory in SQLite"`

## Goal

Scaffold the next sequential Architecture Decision Record and append a row to `.context/decisions/INDEX.md`.

## Workflow

### 1. Allocate number

- List existing files matching `.context/decisions/[0-9][0-9][0-9][0-9]-*.md`.
- Next number = highest + 1, zero-padded to four digits (e.g. `0004`).
- Slug: kebab-case title derived from argument (lowercase, hyphens, no special chars).
- Filename: `.context/decisions/NNNN-<slug>.md`

### 2. Create ADR file

Use this template. Pre-fill sections from user-supplied content when present; otherwise leave guidance placeholders.

```markdown
---
status: inferred
evidence: none — not yet documented
---

# NNNN — <Title>

## Decision

<what was decided, one or two sentences>

## Context

<situation that led to it>

## Rejected alternatives

<what else was considered/why not, or "unknown — not documented">

## Consequences

<tradeoffs accepted>
```

If the user **explicitly confirmed** the reasoning in the current conversation, set `status: confirmed` and `evidence:` to relevant commit SHA, PR link, or `"confirmed in conversation YYYY-MM-DD"`.

Optional frontmatter for supersession:

```yaml
supersedes: NNNN
```

When superseding, update the old ADR's frontmatter with `superseded_by: MMMM` (metadata only — do not edit Decision/Context body of confirmed ADRs).

### 3. Update INDEX.md

Append one row to `.context/decisions/INDEX.md`:

| # | Title | Status | Tags | Summary |

- **Tags:** comma-separated keywords inferred from title/content.
- **Summary:** one sentence from the Decision section.

Do not paste full ADR content into INDEX.md.

### 4. Interactive gap-fill

If Decision, Context, or Consequences are still placeholders, ask the user targeted questions **one section at a time** before closing.

### 5. Report

Confirm:

- Path to new ADR
- Assigned number
- Status (`inferred` vs `confirmed`)
- INDEX row added
- Whether any existing ADR was marked superseded

## Guardrails

- Never reuse or renumber existing ADR files.
- Never edit the body of an existing `status: confirmed` ADR — supersede instead.
- New ADRs start as `inferred` unless user explicitly confirmed in conversation.
