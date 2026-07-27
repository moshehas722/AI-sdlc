# Project Context — Table of Contents

Manifest-driven repo knowledge for AI agents. Start here before deep-diving into individual files.

| File | Description | When to read |
|------|-------------|--------------|
| [business-overview.md](business-overview.md) | Product purpose, stakeholders, domain glossary | Before making product or prioritization judgments; **requires human fill-in** |
| [architecture.md](architecture.md) | Current-state snapshot of components and interactions | Before changing structure, adding skills/personas, or tracing cross-component flows |
| [component-inventory.md](component-inventory.md) | Flat catalog of modules, commands, and artifacts | When you need a path or name and don't need relationship detail |
| [technology-stack.md](technology-stack.md) | Languages, frameworks, and key libraries (scanner-derived) | Before choosing libraries, tooling, or assuming a runtime stack |
| [dependencies.md](dependencies.md) | Full dependency list with versions (tool-generated) | Before upgrading packages, auditing licenses, or citing exact versions |
| [api-documentation.md](api-documentation.md) | HTTP/API or agent I/O contracts | Before calling or modifying external interfaces or skill I/O contracts |
| [conventions.md](conventions.md) | Naming, banners, memory lifecycle, context rules | Before writing new code, skills, commands, or docs in this repo |
| [gotchas.md](gotchas.md) | Non-obvious constraints and footguns | After skimming architecture; before risky edits to persona or context files |
| [decisions/INDEX.md](decisions/INDEX.md) | ADR pointer table | When you need the *why* behind a structural choice; follow links to full ADRs |
| [persona/](persona/) | Per-persona memory, staging, and audit | When adapting persona behavior or reviewing audit history |

## Maintenance commands

| Command | Purpose |
|---------|---------|
| `/context/seed-context` | Full (re)generation pipeline for all context files |
| `/context/update-context <file>` | Regenerate one file (diff review for synthesized files) |
| `/context/new-adr "<title>"` | Scaffold next ADR + INDEX row |
| `/context/retrospective` | Extract session insights → pending memory / draft ADR / proposed diffs |
| `/context/consolidate-memory <persona>` | Dedupe and propose cleanup for persona memory |
| `/context/consolidate-decisions` | Dedupe and propose cleanup for ADRs |

See [README.md](README.md) for human onboarding.
