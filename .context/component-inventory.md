---
status: inferred
verified_against: 2026-07-27
source: static-analysis
---

# Component Inventory

Flat catalog of modules and artifacts. Relationship and flow details are in `architecture.md`.

| Component | Path | Type | Description |
|-----------|------|------|-------------|
| Persona management rule | `.cursor/rules/persona-management.mdc` | Cursor rule | Always-on policy: persona routing, banners, model check, run_mode |
| Developer fix-bug skill | `.cursor/skills/persona/developer/fix-bug/` | Skill | Bug diagnosis and fix workflow (`run_mode: inline`) |
| Developer review-code skill | `.cursor/skills/persona/developer/review-code/` | Skill | Code review workflow (`run_mode: subagent`) |
| Designer write-us skill | `.cursor/skills/persona/designer/write-us/` | Skill | User story authoring (`run_mode: subagent`) |
| Developer persona identity | `.harness/persona/developer.md` | Persona identity | Banner instructions for developer |
| Designer persona identity | `.harness/persona/designer.md` | Persona identity | Banner instructions for designer |
| Persona audit command | `.cursor/commands/persona/persona-audit.md` | Slash command | Session scoring → `.context/persona/<persona>/audit.md` |
| Persona retrospective command | `.cursor/commands/persona/persona-retrospective.md` | Slash command | Extract feedback → `.context/persona/<persona>/memory-staging.md` |
| Persona promote-memory command | `.cursor/commands/persona/persona-promote-memory.md` | Slash command | Promote staging → `.context/persona/<persona>/memory.md` |
| Seed context command | `.cursor/commands/context/seed-context.md` | Slash command | Full `.context/` generation pipeline |
| Update context command | `.cursor/commands/context/update-context.md` | Slash command | Regenerate a single context file |
| New ADR command | `.cursor/commands/context/new-adr.md` | Slash command | Scaffold numbered ADR + INDEX row |
| Context retrospective command | `.cursor/commands/context/retrospective.md` | Slash command | Session insights → pending memory / draft ADR / proposed diffs |
| Consolidate memory command | `.cursor/commands/context/consolidate-memory.md` | Slash command | Dedupe pending/live persona memory |
| Consolidate decisions command | `.cursor/commands/context/consolidate-decisions.md` | Slash command | Dedupe/retire stale ADRs |
| Dependency scanner (PowerShell) | `.context/scripts/scan-dependencies.ps1` | Script | Deterministic manifest parser → JSON |
| Dependency scanner (Bash) | `.context/scripts/scan-dependencies.sh` | Script | Deterministic manifest parser → JSON |
| Project context TOC | `.context/TOC.md` | Manifest | Index of context files with read triggers |
| ADR index | `.context/decisions/INDEX.md` | Manifest | Pointer table for architecture decisions |
| Developer persona memory | `.context/persona/developer/memory.md` | Memory | Live developer behavioral learnings |
| Developer persona memory staging | `.context/persona/developer/memory-staging.md` | Staging | Unapproved developer retrospective insights |
| Developer persona audit | `.context/persona/developer/audit.md` | Audit | Developer session performance history |
| Designer persona memory | `.context/persona/designer/memory.md` | Memory | Live designer behavioral learnings |
| Designer persona memory staging | `.context/persona/designer/memory-staging.md` | Staging | Unapproved designer retrospective insights |
| Designer persona audit | `.context/persona/designer/audit.md` | Audit | Designer session performance history |
