# HarnessStructure

Agentic SDLC harness for Cursor: persona-bound skills (`.cursor/skills/persona/`), always-on persona routing (`.cursor/rules/persona-management.mdc`), persona identity and audit (`.harness/persona/`), persona memory (`.context/memory/`), slash commands for persona and context lifecycle, and a manifest-driven project context system (`.context/`).

This repository is configuration- and documentation-centric — no application runtime or package dependencies at present.

**For full project context, see [.context/TOC.md](.context/TOC.md).**

## Quick links

| Area | Path |
|------|------|
| Context manifest | [.context/TOC.md](.context/TOC.md) |
| Persona skills | `.cursor/skills/persona/` |
| Persona identity + audit | `.harness/persona/` |
| Persona memory | `.context/memory/` |
| Slash commands | `.cursor/commands/` (persona: `.cursor/commands/persona/`, context: `.cursor/commands/context/`) |
| Context onboarding | [.context/README.md](.context/README.md) |

## Context commands

- `/context/seed-context` — generate or refresh all context files
- `/context/update-context <file>` — refresh one file
- `/context/new-adr "<title>"` — new architecture decision record
- `/context/retrospective` — session insights (staging only)
- `/context/consolidate-memory <persona>` — memory maintenance
- `/context/consolidate-decisions` — ADR maintenance

## Persona commands

- `/persona/persona-audit [persona]` — score persona performance this session
- `/persona/persona-retrospective` — extract feedback → `.context/memory/pending/`
- `/persona/persona-promote-memory <persona> <staging-id>` — promote staging → live memory
