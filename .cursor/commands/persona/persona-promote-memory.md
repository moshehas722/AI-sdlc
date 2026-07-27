# Persona Promote Memory

When this command runs, print exactly:

```text
*** USING COMMAND: persona/persona-promote-memory ***
```

This command must **not** select, switch, or clear an active persona.

## Arguments

Parse text after `/persona/persona-promote-memory` as two required arguments:

```text
/persona/persona-promote-memory <persona-name> <staging-memory-id>
```

| Argument | Meaning | Example |
|----------|---------|---------|
| `persona-name` | Persona name (matches `.context/persona/<persona>/memory.md`) | `designer`, `developer` |
| `staging-memory-id` | Value of `Id:` on a staging entry | `stg-20260723-01` |

If either argument is missing or ambiguous, stop and ask for:

```text
/persona/persona-promote-memory <persona-name> <staging-memory-id>
```

## Goal

Promote one staging entry from `.context/persona/<persona>/memory-staging.md` into live `.context/persona/<persona>/memory.md`, then mark the staging entry as merged.

## Workflow

1. **Resolve paths**
   - Staging: `.context/persona/<persona-name>/memory-staging.md`
   - Memory: `.context/persona/<persona-name>/memory.md`
   - If either file is missing, stop and report the error.

2. **Find the staging entry**
   - Read the pending file.
   - Find the entry whose `- Id:` equals `<staging-memory-id>`.
   - If not found, list available pending/accepted ids for that persona and stop.
   - If `Status` is already `merged` or `rejected`, stop and say so (do not re-promote unless the user explicitly asks to force).

3. **Map into active memory**
   - Ensure `.context/persona/<persona-name>/memory.md` uses the active memory shape (create sections if missing; keep the banner instructions if present).
   - Apply promotion rules:

     | Staging signal | → Memory section |
     |----------------|------------------|
     | One-off praise/complaint | Drop or merge into Do / Don't |
     | Repeated preference | Preferences |
     | Process correction | Working patterns |
     | Unclear / conflicting | Open questions |

   - Write a concise bullet under the chosen section from Feedback + Implication.
   - Do not duplicate an equivalent existing bullet; merge if already present.

4. **Update staging status**
   - Set that entry’s `Status` to `merged`.
   - Optionally add `- Promoted: YYYY-MM-DD` and `- Memory section: <section name>`.

5. **Report**
   - Confirm persona, staging id, target memory section, and the bullet added/updated.

## Active memory shape

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

## Guardrails

- Only promote the single requested staging id.
- Do not edit other personas.
- Do not edit `.harness/persona/<persona>.md`.
- Do not invent content beyond the staging entry and clear promotion mapping.
