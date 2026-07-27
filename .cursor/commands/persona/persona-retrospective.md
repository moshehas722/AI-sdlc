# Persona Retrospective

When this command runs, print exactly:

```text
*** USING COMMAND: persona/persona-retrospective ***
```

This command must **not** select, switch, or clear an active persona.

Any text the user typed after `/persona/persona-retrospective` is extra context for the retrospective (e.g. focus on one persona or a specific turn).

## Goal

Read the full conversation, extract user feedback about how each persona performed, and write durable staging notes into `.context/memory/pending/<persona>.md` for every persona that was used (or explicitly discussed).

## Workflow

1. **Inventory personas**
   - List directories under `.harness/persona/` (or `.cursor/skills/persona/`).
   - Ensure each has a `.context/memory/pending/<persona>.md` (create a minimal stub if missing).

2. **Read the conversation and resolve persona scope**
   - Use the full chat history in context.
   - If history may be incomplete, also read relevant agent transcripts under the project's agent-transcripts folder when available.
   - **Primary scope signal:** `=== PERSONA: <persona-name> ===` header lines (from persona switches / first loads).
   - Treat each such header as the start of a persona scope segment that continues until the next `=== PERSONA: ... ===` header (or end of chat).
   - Personas in scope for this retrospective = unique `<persona-name>` values from those headers in this chat, plus any persona the user explicitly named after `/persona/persona-retrospective`.
   - Use `*** USING SKILL: ... ***` only as turn/context detail inside a segment, not as the persona-identity signal.
   - Do not infer persona scope from skill path alone when a persona header is present.

3. **Extract feedback per persona**
   - For each persona in scope, collect user statements about quality, tone, mistakes, preferences, process gaps, and what to do differently next time.
   - Attribute feedback to the persona whose scope segment was active when the related work or user comment occurred (last preceding `=== PERSONA: <persona-name> ===`).
   - Also attribute feedback when the user clearly names that persona.
   - Ignore unrelated chatter. Prefer concrete, actionable notes over vague praise.

4. **Update pending memory**
   - For each persona with relevant feedback, read `.context/memory/pending/<persona>.md`.
   - Append a dated retrospective entry (do not wipe existing staging unless the user asks to reset).
   - Use the **Memory staging entry shape** below.
   - If a persona was used but received no user feedback, leave its pending file unchanged (optionally note that in the chat reply only).

5. **Report**
   - Summarize which personas were updated and the key staging notes added (include each new `Id`).
   - Do not promote staging into live memory here; use `/persona/persona-promote-memory <persona-name> <staging-memory-id>` for that.
   - Do not update audit scores here; use `/persona/persona-audit` (or `/persona/persona-audit <persona-name>`) for session scoring and history.

## Memory entry structures

### Pending memory (`.context/memory/pending/<persona>.md`)

Chronological, append-only intake from this command:

```markdown
# <Persona> Memory Staging

## Retrospective YYYY-MM-DD

- Id: stg-YYYYMMDD-NN
- Feedback: what the user said about this persona’s performance
- Context: persona header segment + skill/turn (e.g. after `=== PERSONA: developer ===`, `/fix-bug`)
- Implication: what to change or keep
- Confidence: high | medium | low
- Status: pending
```

Assign `Id` as `stg-YYYYMMDD-NN` (zero-padded sequence per persona per day, starting at `01`).  
Optional later fields when staging is reviewed: `Status: accepted | rejected | merged`.  
Promote a specific entry with `/persona/persona-promote-memory <persona-name> <staging-memory-id>`.

### Active memory (`.context/memory/<persona>.md`)

Promote only durable, actionable notes — grouped by theme, not by chat turn:

```markdown
# <Persona> Memory

## Preferences
- Tone, verbosity, when to ask vs act

## Working patterns
- How this persona should approach tasks in this repo

## Do
- Concrete behaviors that worked

## Don't
- Mistakes or patterns to avoid

## Open questions
- Unresolved user preferences still being tested
```

### Promotion rules

| Staging | → Memory |
|---------|----------|
| One-off praise/complaint | Drop or merge into Do/Don't |
| Repeated preference | Preferences |
| Process correction | Working patterns |
| Unclear / conflicting | Open questions |

## Guardrails

- Do not edit `persona.md` or `.context/memory/<persona>.md` in this command.
- Do not invent feedback the user did not give.
- Keep staging entries concise and persona-scoped.
