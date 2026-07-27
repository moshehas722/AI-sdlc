# Update Context

When this command runs, print exactly:

```text
*** USING COMMAND: context/update-context ***
```

This command must **not** select, switch, or clear an active persona.

## Arguments

```text
/context/update-context <file>
```

| Input | Behavior |
|-------|----------|
| `<file>` | Basename or path under `.context/` (e.g. `dependencies.md`, `architecture.md`, `decisions/0001-*.md` is **not** valid — ADRs use `/context/new-adr` or manual edit) |

If the argument is missing, stop and ask:

```text
/context/update-context <file>
```

Examples: `dependencies.md`, `technology-stack.md`, `architecture.md`, `conventions.md`, `gotchas.md`, `api-documentation.md`, `component-inventory.md`, `TOC.md`

## Goal

Re-run generation for a **single** context file. Behavior depends on file type.

## File-type behavior

### Deterministic — safe overwrite

Regenerate freely; re-stamp `verified_against` (git SHA or ISO date). No diff review required unless user asks.

| File | Tooling |
|------|---------|
| `dependencies.md` | `.context/scripts/scan-dependencies.ps1` (or `.sh`) |
| `technology-stack.md` | Summary from scanner output only |
| `api-documentation.md` | OpenAPI/schema parsers if present; else code inference |

Workflow:

1. Run deterministic tooling; capture raw output.
2. Regenerate the target file from that output.
3. Write file directly.
4. Report: file updated, new `verified_against`, package/manifest counts.

### Synthesized — diff for review

Generate a **new version** internally; **do not silently overwrite**.

| File | Method |
|------|--------|
| `architecture.md` | Rescan repo structure; preserve ADR link style |
| `component-inventory.md` | Static analysis pass |
| `conventions.md` | Representative code sample |
| `gotchas.md` | Comment mining + guardrails |

Workflow:

1. Read current file.
2. Run focused regeneration pass for that file only.
3. Present a **unified diff** (or side-by-side summary) to the user.
4. Ask whether to apply. Apply only on explicit user approval.
5. If applied, set `verified_against` and keep prior `status` unless user confirms → `confirmed`.

### Protected — do not auto-generate content

| File | Behavior |
|------|----------|
| `business-overview.md` | Refuse auto-generation. Offer to refresh frontmatter date only, or remind user to fill manually. |
| `decisions/*.md` | Do not regenerate in place. Use `/context/new-adr` or superseding ADR for changes. |
| `persona/<persona>/memory.md` | Do not overwrite live memory. Use `/context/retrospective` + `/context/consolidate-memory`. |
| `decisions/INDEX.md`, `TOC.md` | Rebuild from sibling files if requested; present diff if rows would be removed. |

## After update

If the updated file is referenced in `TOC.md` or `decisions/INDEX.md`, offer to refresh those indices.

## Guardrails

- Never guess dependency versions.
- Never overwrite `status: confirmed` ADRs.
- Never silently overwrite synthesized files.
- One file per invocation — do not batch.
