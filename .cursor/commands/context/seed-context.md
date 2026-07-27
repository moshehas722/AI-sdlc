# Seed Context

When this command runs, print exactly:

```text
*** USING COMMAND: context/seed-context ***
```

This command must **not** select, switch, or clear an active persona.

## Goal

Run the full `.context/` generation pipeline for the current repository: discovery → deterministic tooling → per-file synthesis → ADR candidates → manifest assembly → summary report.

## Workflow

Execute steps **in order**. Do not combine multiple target files into one giant generation prompt.

### 1. Discovery pass

Scan and collect evidence:

- Repository tree (top-level and notable subtrees).
- Package manifests: `package.json`, `requirements*.txt`, `pyproject.toml`, `Cargo.toml`, `go.mod`, `*.csproj`.
- Existing README, docs, `AGENTS.md`.
- OpenAPI/GraphQL/schema/route definition files if present.
- Git log (if repo is initialized): prioritize commits with dependency changes, large refactors, deletions, renames.
- Code comments matching `NOTE:`, `WARNING:`, `FIXME:`, `HACK:`, "we don't", "because".

Record discovery notes internally; do not dump raw tree into context files.

### 2. Deterministic tooling (run before any LLM synthesis)

Run dependency scanner and capture raw JSON:

```powershell
powershell -NoProfile -File .context/scripts/scan-dependencies.ps1
```

On Unix:

```bash
bash .context/scripts/scan-dependencies.sh
```

Use scanner output **verbatim** for:

- `.context/dependencies.md`
- `.context/technology-stack.md` (summary derived from scanner output only — no version guessing)

For API docs: if OpenAPI/GraphQL/schema files exist, parse them with appropriate tooling first. Otherwise infer from route/handler code and mark `status: inferred`.

Set `verified_against` to current git commit SHA if available, else today's ISO date.

### 3. Per-file generation (one focused pass each)

Generate or refresh each file in a **separate** focused step:

| File | Method | Notes |
|------|--------|-------|
| `business-overview.md` | **Placeholder only** | `status: needs-human-input`; never fabricate content |
| `architecture.md` | LLM synthesis | Current-state snapshot; link to ADRs for "why" — no inline rationale |
| `component-inventory.md` | Static analysis | Flat catalog; no relationship info |
| `technology-stack.md` | From scanner | Short summary table |
| `dependencies.md` | From scanner | Full list with versions |
| `api-documentation.md` | Schema parse or code inference | Mark inferred if no schemas |
| `conventions.md` | Sample-based synthesis | Read representative files, not whole repo |
| `gotchas.md` | Comment mining + guardrails | Flag low-confidence items |
| `decisions/*.md` | Evidence-based ADRs | `status: inferred`; sequential numbering |
| `persona/<persona>/memory.md` | Stub if missing | Empty section scaffold; do not invent learnings |
| `persona/<persona>/memory-staging.md` | Stub if missing | Do not populate unless retrospective data exists |
| `persona/<persona>/audit.md` | Stub if missing | Audit template from `/persona/persona-audit` command |

### 4. ADR candidates

From discovery evidence, create candidate ADRs in `.context/decisions/`:

- Number sequentially: `0001-`, `0002`, …
- Use ADR template (Decision, Context, Rejected alternatives, Consequences).
- Frontmatter: `status: inferred`, `evidence: [commit-sha or "none — reconstructed from code"]`.
- Do not mark `confirmed` unless human explicitly confirmed in this session.

### 5. Assemble manifests last

After all files exist:

- **`.context/TOC.md`** — one row per top-level file; actionable "When to read" triggers; exclude `decisions/` and `persona/` internals (link to their indices).
- **`.context/decisions/INDEX.md`** — pointer table only; one row per ADR.

### 6. Config checks

- Ensure `.context/` is **not** excluded by `.gitignore`.
- If `.cursorignore` exists with broad dotfolder exclusions, append after the overriding pattern:

  ```
  !.context/
  !.context/**
  ```

- Ensure root `AGENTS.md` points to `.context/TOC.md`.

### 7. Summary report

Print a structured summary:

```markdown
## Seed context — complete

### Files generated / updated
- <file> — <status> — <source>

### Confidence
- High (tool-generated): dependencies.md, technology-stack.md
- Medium (static analysis): component-inventory.md
- Low / draft (inferred): architecture.md, conventions.md, gotchas.md, ADRs

### Needs human input
- business-overview.md (required)
- ADRs with evidence: none — reconstructed from code (list numbers)
- Any file marked status: inferred that affects production decisions

### Next steps
1. Fill business-overview.md
2. Review inferred ADRs → set status: confirmed when accepted
3. Run /context/update-context <file> after structural changes
```

## Guardrails

- Do not fabricate business-overview.md content.
- Do not guess dependency versions or API signatures.
- Do not embed ADR rationale inside architecture.md.
- Do not auto-merge anything into live memory or confirmed ADRs.
- Do not overwrite human-edited files with `status: confirmed` without explicit user approval in this session.

## Reference

Human onboarding: `.context/README.md`
