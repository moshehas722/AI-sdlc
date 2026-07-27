---
status: inferred
evidence: none — reconstructed from code; structural refactor 2026-07-27
supersedes: 0002
superseded_by: 0005
---

# 0004 — Persona memory lives in `.context/memory/`

## Decision

Live persona memory (`.context/memory/<persona>.md`) and staging (`.context/memory/pending/<persona>.md`) are the single canonical location for persona behavioral learnings. `.harness/persona/<persona>/` retains only identity (`persona.md`) and audit (`audit.md`).

## Context

Persona memory existed in two parallel trees (`.harness/persona/*/memory.md` and `.context/memory/`), causing duplication and split maintenance. Consolidating into `.context/memory/` aligns persona learnings with the project context system while keeping lightweight persona identity in `.harness/`.

## Rejected alternatives

- **Keep dual locations with sync** — rejected; sync drift and duplicate promotion paths.
- **Move everything including persona.md to `.context/`** — rejected for now; persona identity banners are tightly coupled to skill routing and remain in `.harness/`.

## Consequences

- Persona switch loads `.harness/persona/<persona>/persona.md` + `.context/memory/<persona>.md`.
- `/persona/persona-retrospective` and `/persona/persona-promote-memory` read/write `.context/memory/` paths.
- New personas require `.context/memory/<persona>.md` and `.context/memory/pending/<persona>.md` stubs in addition to `.harness/persona/<persona>/persona.md`.

> **Superseded by [0005](0005-persona-memory-under-context-persona.md)** — memory relocated to `.context/persona/<persona>/`.
