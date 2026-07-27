# Project Context System (`.context/`)

Structured, on-demand repo knowledge for AI agents (Cursor, Claude Code, and similar tools). A manifest-driven folder the agent reads selectively instead of re-scanning the whole repository every session.

## Quick start

1. Open **[TOC.md](TOC.md)** — pick files by *when to read*, not by reading everything.
2. Fill in **[business-overview.md](business-overview.md)** — the one file agents must not invent from code.
3. Run **`/context/seed-context`** on a new clone or after major structural changes.
4. Run **`/context/update-context <file>`** when one area drifts (e.g. after adding `package.json`).

## Layout

```
.context/
├── TOC.md                 ← start here
├── *.md                   ← top-level context topics
├── decisions/             ← numbered ADRs + INDEX.md
├── memory/                ← per-persona behavioral learnings
│   └── pending/           ← retrospective staging (never auto-merged)
└── scripts/               ← deterministic tooling (dependency scanner)
```

## File confidence model

Every generated file includes YAML frontmatter:

```yaml
---
status: inferred | confirmed | generated | needs-human-input
verified_against: <git sha or ISO date>
source: static-analysis | llm-synthesis | human-authored
---
```

| Status | Meaning |
|--------|---------|
| `generated` | Produced by deterministic tooling (dependencies, scanner output) |
| `inferred` | LLM synthesis from code/docs — treat as draft |
| `confirmed` | Human-reviewed |
| `needs-human-input` | Placeholder only (business overview) |

## Rules agents must follow

1. **Never fabricate** `business-overview.md` from source code.
2. **Never guess** dependency versions or API signatures — use scanner output or schema files.
3. **Never embed ADR rationale** in `architecture.md` — link to `decisions/` instead.
4. **Never edit confirmed ADRs in place** — supersede with a new numbered ADR.
5. **Never auto-merge** `/context/retrospective` output into live memory or confirmed ADRs.

## ADRs

Architecture Decision Records live in `decisions/NNNN-title.md`. See `decisions/INDEX.md` for the pointer table. Create new ones with `/context/new-adr "<title>"`.

## Persona memory vs repo facts

| Location | Holds |
|----------|-------|
| `.context/*.md` (top-level) | Repo facts: architecture, stack, conventions |
| `.context/memory/<persona>.md` | Live persona behavioral learnings (loaded on persona switch) |
| `.context/memory/pending/<persona>.md` | Staged insights awaiting promotion |
| `.harness/persona/<persona>/persona.md` | Persona identity and banner instructions |
| `.harness/persona/<persona>/audit.md` | Session performance audit history |

## Slash commands

Defined in `.cursor/commands/context/`:

- `/context/seed-context` — full pipeline
- `/context/update-context <file>` — single-file refresh
- `/context/new-adr "<title>"` — new decision record
- `/context/retrospective` — session learnings (staging only)
- `/context/consolidate-memory <persona>` — memory maintenance
- `/context/consolidate-decisions` — ADR maintenance

## Cross-tool discoverability

Root **[AGENTS.md](../AGENTS.md)** points agents here from outside Cursor-specific paths.

## Contributing

- Confirm inferred files when reviewed: set `status: confirmed` and update `verified_against`.
- Prefer `/context/update-context` over hand-editing generated files.
- Keep `TOC.md` and `decisions/INDEX.md` updated when adding top-level files or ADRs.
