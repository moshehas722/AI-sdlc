# Persona Audit

When this command runs, print exactly:

```text
*** USING COMMAND: persona/persona-audit ***
```

This command must **not** select, switch, or clear an active persona.

## Arguments

```text
/persona/persona-audit [persona-name]
```

| Input | Behavior |
|-------|----------|
| (none) | Audit every persona used or discussed in this chat |
| `persona-name` | Audit only that persona (e.g. `designer`) |

## Goal

Score how the persona performed **in this session**, append a history row, and refresh the **Current** scorecard so trends are visible over time.

File: `.harness/persona/<persona>/audit.md`

## Workflow

1. **Resolve personas**
   - If an argument is given, use that persona only.
   - Otherwise infer from banners / `.cursor/skills/persona/<persona>/` usage in the chat.
   - Ensure `.harness/persona/<persona>/audit.md` exists (create from the template below if missing).

2. **Score this session (1–5)**
   - Use user feedback in the chat, staging entries (`.context/memory/pending/<persona>.md`), and observed behavior.
   - Score: Accuracy, Completeness, Consistency, Instruction fidelity, Scope discipline, Feedback uptake, Risk.
   - `Overall` = round(average of the dimension scores), unless the user states an overall.
   - Do not invent praise; if evidence is thin, score conservatively and note low confidence in Trigger/notes.

3. **Append session history**
   - Session id: `sess-YYYYMMDD-NN` (per persona per day, starting at `01`).
   - On the **first** real audit, replace the seed `—` history row instead of appending beside it.
   - Append one row (newest at the bottom) with all dimension scores + short trigger/notes (e.g. `retrospective stg-…`, `user: too verbose`).

4. **Update Current scorecard**
   - Set `Updated` to today.
   - Copy this session’s scores into **Current**.
   - Set each **Trend** by comparing to the previous history row (↑ / ↓ / →). If no previous real row, use `→`.
   - Recompute **Maturity** only using gates in the file (do not skip levels).

5. **Maintain failure modes / gates**
   - Add or refine failure modes when the user cites a repeated problem.
   - Update “Gate to next maturity” when a gate is met or the bar should change.

6. **Report**
   - For each audited persona: session id, Overall, trends vs last session, and path to `audit.md`.

## File shape

```markdown
# <Persona> Audit

## Current

- Updated: YYYY-MM-DD
- Maturity: experimental | emerging | reliable | trusted
- Overall: N

| Dimension | Score | Trend | Notes |
|-----------|-------|-------|-------|
| Accuracy | | ↑↓→ | |
| Completeness | | | |
| Consistency | | | |
| Instruction fidelity | | | |
| Scope discipline | | | |
| Feedback uptake | | | |
| Risk | | | |

## Session history

| Session | Date | Overall | Accuracy | Completeness | Consistency | Instruction fidelity | Scope discipline | Feedback uptake | Risk | Trigger / notes |
|---------|------|---------|----------|--------------|-------------|----------------------|------------------|-----------------|------|-----------------|
| sess-YYYYMMDD-NN | YYYY-MM-DD | | | | | | | | | |

## Failure modes

- …

## Gate to next maturity

- …
```

## How to read it

- **Current** = latest performance (what to trust now).
- **Session history** = full trail; scan the Overall (and any dimension) column for trend over sessions.
- Staging/retrospective captures *what the user said*; audit captures *scored performance per session*.

## Guardrails

- Append history; never rewrite past session rows (except removing the seed row on first audit).
- Only change **Current** to match the newest session.
- Do not edit `persona.md`, `.context/memory/<persona>.md`, or `.context/memory/pending/<persona>.md` in this command.
