---
status: generated
verified_against: 2026-07-27
source: static-analysis
---

# Technology Stack

Generated from dependency scanner output (`.context/scripts/scan-dependencies.ps1`). No package manifests were found in this repository at seed time.

## Runtime

| Layer | Value |
|-------|-------|
| Language | None (markdown/YAML configuration repository) |
| Framework | Cursor agent harness (rules, skills, commands) |
| Database | None |
| Build tool | None |

## Agent tooling

| Tool | Role |
|------|------|
| Cursor IDE | Host for rules, skills, slash commands |
| Markdown + YAML frontmatter | Skill contracts, persona docs, context files |
| PowerShell / Bash | Deterministic dependency scanning scripts |

## Key libraries

_No third-party runtime dependencies detected._ Scanner checked: `package.json`, `requirements*.txt`, `pyproject.toml`, `Cargo.toml`, `go.mod`, `*.csproj`.

Re-run `/context/update-context technology-stack.md` after adding dependency manifests.
