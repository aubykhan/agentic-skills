# agentic-skills

A collection of skill guides for facilitating quarterly engineering performance reviews. These skills help engineering managers assess direct reports objectively using structured conversation or scorecard modes with competency-based frameworks.

## Skill-based Usage

Skills are managed by the AI agent as **opencode skills** and loaded automatically when the task matches their description. The core skill lives in `.claude/skills/quarterly-review-unified/`.

### [quarterly-review-unified](.claude/skills/quarterly-review-unified/SKILL.md)

The primary unified guide for quarterly engineering performance reviews. Supports two modes:
- **Conversation Mode** — Structured Q&A with competency-level probes for narrative, calibration-ready evidence. Uses MCP evidence (Jira, Slack, Confluence, GitHub) to back or counter claims.
- **Scorecard Mode** — Y/P/N tally format with compact input to reduce cognitive load. Two-phase scoring (current bar first, next-level optional) with pillar batching.

Detects and normalizes matrix layout rubrics (level × pillar × dimension) from external competency sheets (xlsx/csv/ods or pasted tables) into review prompts. Falls back to a built-in default rubric when no external sheet is provided.

**Covers:** Performance rating (1–5), Potential assessment (High/Mid/Low), 9-box placement, calibration-ready evidence, Manager Confidence, Self-Assessment notes.

### Features

- **Matrix detection** — Automatically detects archetypes (flat list, pillar × level ladder, dimension × level × expectation, theme × level columns) and normalizes them
- **Two-phase scoring** — Current bar performance rating first, optional next-level readiness separately
- **Pillar batching** — Groups competency items to reduce cognitive load on long lists
- **Compact input** — Accepts single-line Y/P/N answers and table pastes
- **Built-in fallback rubric** — Works without an external competency sheet
- **MCP evidence integration** — Soft-optional Jira, Slack, Confluence, GitHub lookups
- **AskQuestion UI** — Prefers native blocking checkbox/radio UI; falls back to text menus if unavailable

## How to Use

1. Ensure `quarterly-review-unified` skill is available in your opencode configuration
2. Ask the AI to run a quarterly review or performance assessment
3. Follow the prompts to select mode, provide employee info, and assess competencies
4. Review the generated output (evidence summary, ratings, 9-box placement, calibration summary)

## Archived

Legacy standalone guides moved to [old/archive/](old/archive/):
- `performance-review.md` — Original unified guide
- `performance-review-fixed-competencies.md` — Conversation mode with embedded level-specific questions
- `performance-review-fixed-competencies-quick.md` — Quick scorecard questionnaire
