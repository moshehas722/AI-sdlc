---
status: confirmed
verified_against: 2026-07-28
source: human-authored
---

# Persona System

Overview of the persona system: how personas are defined, selected, loaded, and maintained over time.

For component paths and cross-system interactions, see [architecture.md](architecture.md) and [component-inventory.md](component-inventory.md).

## Current status

Snapshot as of **2026-07-28**. Routing rules, file layout, and lifecycle commands are in place; persona content and skill workflows are still scaffold-level.

### Implementation

| Area | Count | Notes |
|------|-------|-------|
| Active personas | 2 | `developer`, `designer` |
| Persona skills | 3 | Under `.cursor/skills/persona/` |
| Persona commands | 3 | `persona-audit`, `persona-retrospective`, `persona-promote-memory` |
| Routing policy | 1 | `.harness/rules/persona-instructions.mdc` (loaded via `.cursor/rules/harness.mdc`) |

### Persona and skill inventory

| Persona | Skill | `model` | `run_mode` | Workflow state |
|---------|-------|---------|------------|----------------|
| developer | fix-bug | `default` | `inline` | Stub — placeholder task text in `SKILL.md` |
| developer | review-code | `default` | `subagent` | Stub — placeholder task text in `SKILL.md` |
| designer | write-us | `gpt-5.2` | `subagent` | Stub — placeholder task text in `SKILL.md`; triggers model-mismatch confirmation when chat model differs |

Persona identity files (`.harness/persona/developer.md`, `.harness/persona/designer.md`) are also stubs — banner instructions only, no role-specific guidance yet.

### Per-persona state

| Persona | Live memory | Staging | Audit |
|---------|-------------|---------|-------|
| developer | Template only (empty sections) | 1 pending entry (`stg-20260723-01`) | Maturity `experimental`; seed row only — no sessions scored |
| designer | Template only (empty sections) | Empty | Maturity `experimental`; seed row only — no sessions scored |

### Open items

- Replace stub `SKILL.md` workflows with real task instructions per skill contract.
- Flesh out persona identity in `.harness/persona/<persona>.md`.
- Review and promote (or drop) developer staging entry `stg-20260723-01`.
- Run `/persona/persona-audit` after real skill sessions to seed audit history.

## Purpose

Personas give the agent role-specific identity and behavioral memory for certain skills. When a user invokes a persona-bound skill, the agent:

1. Selects the matching persona
2. Loads identity and live memory
3. Emits visible banner lines (for traceability in chat)
4. Runs the skill workflow (inline or via subagent)

Skills outside the persona tree behave as normal Cursor skills and do not touch persona state.

## File structure

```
.cursor/
├── rules/
│   └── harness.mdc                # Loads harness rules into Cursor
├── skills/persona/
│   └── <persona>/
│       └── <skill>/
│           ├── SKILL.md           # Skill workflow (task instructions only)
│           └── skill.yaml         # Contract: persona, model, run_mode, I/O
└── commands/persona/
    ├── persona-retrospective.md   # Extract feedback → memory-staging
    ├── persona-promote-memory.md  # Promote one staging entry → live memory
    └── persona-audit.md           # Score session performance → audit.md

.harness/
├── rules/
│   ├── context-instructions.mdc   # Context access policy
│   └── persona-instructions.mdc   # Routing, banners, run_mode policy
└── persona/
    └── <persona>.md               # Persona identity (routing + banner text)

.context/persona/
└── <persona>/
    ├── memory.md                  # Live behavioral learnings (loaded on switch)
    ├── memory-staging.md          # Pending retrospective intake (not live)
    └── audit.md                   # Session scorecards and history
```

### What lives where

| Location | Role | Loaded when | Mutable by |
|----------|------|-------------|------------|
| `.cursor/skills/persona/<persona>/<skill>/` | Skill definition + I/O contract | Skill invoked | Manual edit |
| `.harness/persona/<persona>.md` | Persona identity | Persona switch | Manual edit |
| `.context/persona/<persona>/memory.md` | Live behavior rules | Persona switch | `/persona/persona-promote-memory` |
| `.context/persona/<persona>/memory-staging.md` | Unapproved feedback | Not loaded | `/persona/persona-retrospective`, `/context/retrospective` |
| `.context/persona/<persona>/audit.md` | Performance history | Not loaded | `/persona/persona-audit` |

**Data boundary:** Repo facts (architecture, conventions, ADRs) live in `.context/` top-level files. Persona-specific *behavior* lives under `.context/persona/<persona>/`. Persona *identity* stays in `.harness/persona/` for tight coupling with skill routing.

## Selection and routing behavior

Persona management is governed by `.harness/rules/persona-instructions.mdc` (loaded via `.cursor/rules/harness.mdc`).

### Scope

Persona logic applies **only** to skills under `.cursor/skills/persona/`. All other skills leave the active persona unchanged.

### Selection flow

1. User invokes a skill whose path is under `.cursor/skills/persona/`.
2. Agent reads `skill.yaml` and uses the `persona` field as the **sole authority** for which persona to load (path segments are not used for routing).
3. Agent validates:
   - `skill.yaml` exists (missing → configuration error, stop)
   - `persona` is present and non-empty (missing → configuration error, stop)
   - `model` vs current chat model (see **Model check** below)
4. Agent resolves `.harness/persona/<persona>.md` and `.context/persona/<persona>/memory.md` for the yaml-declared persona (either missing → hard failure; no fallback to previous persona).
5. Agent compares resolved persona to **active persona** for this conversation:
   - **Same persona** → do not reload files; emit skill banner only
   - **Different persona** (or first load) → switch active persona, load identity + memory, emit full banner block
6. Agent executes skill per `run_mode` in `skill.yaml`.

### Active persona rules

- One active persona per conversation (initially none).
- A switch replaces the previous persona; two personas are never active at once.
- Persona/memory files are re-read only on switch (or first load), not on every skill invocation within the same persona.

### Model check

Before banners or skill work:

| `skill.yaml` `model` | Behavior |
|----------------------|----------|
| `default` or missing | Use current chat model; no prompt |
| Matches current model | Continue |
| Differs from current model | Stop and ask user to confirm before proceeding |

When a skill declares a non-`default` model and the chat uses a different model, the agent must ask before continuing.

## Banner behavior

Banners are a **single reply prefix** — a fenced `text` code block at the start of the assistant reply. They make persona/skill usage visible in chat and in retrospective/audit scope detection.

### On persona switch or first load

```text
=== PERSONA: <persona-name> ===
*** USING PERSONA: <persona-name> ***
*** LOADED MEMORY FOR PERSONA: <persona-name> ***
*** USING SKILL: <skill-name> ***
```

### When the same persona is already active

```text
*** USING SKILL: <skill-name> ***
```

### Rules

- Each banner line is on its own line inside one fenced block.
- No prose before the block.
- Do not repeat the banner block later in the same reply.
- Do not join multiple banners on one line.

Persona commands use a separate banner shape: `*** USING COMMAND: persona/<command-name> ***`. Commands do **not** select, switch, or clear the active persona.

## Skill contract (`skill.yaml`)

Every persona skill requires:

```yaml
persona: <name>          # Sole authority for persona selection (required, non-empty)
model: default           # Or a specific model slug
run_mode: inline         # inline | subagent

input:
  description: ...
  required: [...]
  optional: [...]

output:
  description: ...
  artifacts: [...]
```

### Run modes

| Mode | Parent agent | Subagent |
|------|--------------|----------|
| `inline` | Runs full skill workflow | N/A |
| `subagent` | Prints banners, launches exactly one Task subagent, renders returned artifacts | Runs skill workflow; must **not** print persona banners |

Choose `inline` for tight interactive loops; choose `subagent` for heavy analysis or large artifact generation that should run isolated from the parent response.

### Skill sequencing

- Skills contain task workflow only — they must not instruct persona loading.
- When multiple persona skills apply in one turn, follow any sequencing rules defined in the relevant skill workflows or agent rules (e.g. review before fix when both are in scope).

## Memory lifecycle

Behavioral learnings follow a staging → promotion pipeline. Nothing is auto-promoted.

```
User feedback in chat
        │
        ▼
/persona/persona-retrospective  ──►  memory-staging.md  (append-only, Status: pending)
        │
        ▼
/persona/persona-promote-memory <persona> <staging-id>
        │
        ▼
memory.md  (live — loaded on next persona switch)
```

### Live memory shape (`.context/persona/<persona>/memory.md`)

Grouped by theme, not by chat turn:

- **Preferences** — tone, verbosity, when to ask vs act
- **Working patterns** — how this persona should approach tasks
- **Do** — behaviors that worked
- **Don't** — mistakes or patterns to avoid
- **Open questions** — unresolved preferences still being tested

### Staging entry shape (`.context/persona/<persona>/memory-staging.md`)

```markdown
## Retrospective YYYY-MM-DD

- Id: stg-YYYYMMDD-NN
- Feedback: ...
- Context: persona segment + skill/turn
- Implication: what to change or keep
- Confidence: high | medium | low
- Status: pending
```

Staging IDs use prefix `stg-` (persona retrospective) vs `ctx-stg-` (context retrospective). Both commands can append to persona staging; only `/persona/persona-promote-memory` writes live memory.

### Promotion mapping

| Staging signal | Target memory section |
|----------------|----------------------|
| One-off praise/complaint | Drop or merge into Do / Don't |
| Repeated preference | Preferences |
| Process correction | Working patterns |
| Unclear / conflicting | Open questions |

## Audit lifecycle

`/persona/persona-audit [persona-name]` scores how a persona performed **in the current session** and writes to `.context/persona/<persona>/audit.md`.

- **Current** scorecard = latest session (what to trust now)
- **Session history** = append-only trail (`sess-YYYYMMDD-NN` IDs)
- Dimensions (1–5): Accuracy, Completeness, Consistency, Instruction fidelity, Scope discipline, Feedback uptake, Risk
- **Maturity** levels: experimental → emerging → reliable → trusted

Audit does not edit memory or staging. Retrospective captures *what the user said*; audit captures *scored performance*.

## Adding a new persona

1. Create `.cursor/skills/persona/<persona>/<skill>/` with `SKILL.md` + `skill.yaml` for each skill.
2. Create `.harness/persona/<persona>.md` (identity + `*** USING PERSONA:` banner line).
3. Create `.context/persona/<persona>/` with stubs:
   - `memory.md` (live memory template + `*** LOADED MEMORY FOR PERSONA:` banner line)
   - `memory-staging.md`
   - `audit.md` (seed row template)

Ensure `skill.yaml` includes a non-empty `persona` field. Skills moved outside `.cursor/skills/persona/` silently stop selecting personas. Folder layout under the persona tree is organizational; routing uses `skill.yaml` only.

## Gotchas

- **Persona comes from `skill.yaml` only** — folder names under `.cursor/skills/persona/` are not used for routing.
- **Missing persona files are hard failures** — no silent fallback to the previous persona.
- **Model mismatch blocks the skill** until the user confirms.
- **Retrospective never writes live memory** — promotion is always explicit.
- **Audit history is append-only** — past session rows are not rewritten (except removing the seed row on first real audit).
- **Banner scope for retrospective** — `=== PERSONA: <name> ===` headers define persona segments in chat history; `*** USING SKILL:` is context detail only.

## Related decisions

| ADR | Topic |
|-----|-------|
| [0001](decisions/0001-persona-skills-under-cursor-tree.md) | Persona skills only under `.cursor/skills/persona/` |
| [0007](decisions/0007-persona-from-skill-yaml.md) | Persona selection from `skill.yaml` `persona` field only |
| [0003](decisions/0003-subagent-run-mode-for-heavy-skills.md) | When to use `run_mode: subagent` |
| [0006](decisions/0006-persona-identity-flat-audit-in-context.md) | Flat identity in `.harness/`; audit with memory in `.context/persona/` |

See also [architecture.md](architecture.md) for the current persona/skill inventory and component interactions, and [conventions.md](conventions.md) for naming and banner conventions.
