---
status: inferred
verified_against: 2026-07-27
source: llm-synthesis
---

# Conventions

Derived from a representative sample of existing files (persona-instructions rule, skill.yaml contracts, command markdown, persona docs). Patterns not enforced by lint/CI.

## Persona and skills

- Persona-bound skills live only under `.cursor/skills/persona/` (typically organized as `<persona>/<skill>/`).
- Every persona skill has a `skill.yaml` with `persona`, `model`, `run_mode`, `input`, and `output`.
- `skill.yaml` `persona` is the sole authority for persona selection; path segments are organizational only.
- Skills outside the persona tree do not trigger persona selection.

## Banners

- Persona switch replies start with a fenced `text` code block containing banner lines.
- On switch: four lines (`=== PERSONA:`, `*** USING PERSONA:`, `*** LOADED MEMORY:`, `*** USING SKILL:`).
- Same persona already active: one line (`*** USING SKILL:` only).
- Never join multiple banners on one line or repeat the block in the same reply.

## Persona files

- Live persona identity: `.harness/persona/<persona>.md`.
- Live persona memory, staging, audit: `.context/persona/<persona>/memory.md`, `memory-staging.md`, `audit.md`.
- Memory promotion is explicit via `/persona/persona-promote-memory`; staging is append-only from `/persona/persona-retrospective`.
- Audit scores session performance; does not edit memory.

## Commands

- Commands print `*** USING COMMAND: <namespace>/<name> ***` as their banner.
- Slash commands live in `.cursor/commands/<namespace>/` and invoke as `/<namespace>/<command>` (e.g. `/context/seed-context`, `/persona/persona-audit`).
- Commands do not select or switch personas unless explicitly part of their workflow.

## Context files

- Generated context files use YAML frontmatter: `status`, `verified_against`, `source`.
- ADRs are immutable once `status: confirmed`; reversals create a new ADR with `supersedes` / `superseded_by`.
- `architecture.md` states facts and links to ADRs — no inline decision rationale.

## Agent entry points

- **`AGENTS.md` is a lean pointer only** — one-paragraph overview, link to `.context/TOC.md`, and references to Cursor rules. Do not duplicate command lists, path tables, or rule content from `.cursor/rules/` or `.context/`.

## Naming

- Persona names: lowercase single token (`developer`, `designer`).
- Skill folders: kebab-case (`fix-bug`, `write-us`, `review-code`).
- ADR files: `NNNN-kebab-title.md` (zero-padded sequence).
- Staging IDs: `stg-YYYYMMDD-NN` (persona retrospective) or `ctx-stg-YYYYMMDD-NN` (context retrospective); audit session IDs: `sess-YYYYMMDD-NN`.
