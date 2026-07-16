# AskQuestion catalog — every closed choice in the workflow

Authoritative payloads for every closed-choice moment. Use with the native **`AskQuestion`** tool when available. If `AskQuestion` is **rejected by the platform**, reuse the **same ids, prompts, and options** in **text-fallback** after printing the mandatory warning — see [interaction.md](interaction.md). Do not invent different menus.

Conventions:
- `allowMultiple` defaults to `false` (radio) when omitted.
- Batch questions that belong to the same moment into **one** `AskQuestion` call (shown as multiple `questions` entries).
- Read answers back by `id`.
- Prompts here are canonical; you may lightly adapt wording, but keep ids and option sets stable.

---

## 1. Setup (Step 0) — batched, one call

```json
{
  "title": "Quarterly review setup",
  "questions": [
    { "id": "mode", "prompt": "Which review mode?", "allowMultiple": false,
      "options": [
        { "id": "conversation", "label": "Conversation — narrative, one area at a time" },
        { "id": "scorecard", "label": "Scorecard — Y/P/N tally, faster" }
      ] },
    { "id": "self_assessment", "prompt": "Do you have an employee self-assessment?", "allowMultiple": false,
      "options": [
        { "id": "yes", "label": "Yes — I'll paste or attach it next" },
        { "id": "no", "label": "No self-assessment this period" }
      ] },
    { "id": "evidence", "prompt": "Pull supporting evidence from MCP? (optional)", "allowMultiple": true,
      "options": [
        { "id": "jira", "label": "Jira" },
        { "id": "slack", "label": "Slack (themes only)" },
        { "id": "confluence", "label": "Confluence" },
        { "id": "github", "label": "GitHub" },
        { "id": "skip", "label": "Skip for now" }
      ] },
    { "id": "competency", "prompt": "Competency source?", "allowMultiple": false,
      "options": [
        { "id": "file", "label": "Provide a file path" },
        { "id": "paste", "label": "Paste a table" },
        { "id": "default", "label": "Use default rubric (SWE→PSE)" }
      ] }
  ]
}
```

**Redirect skills:** when mode is preselected (conversation/scorecard redirect), keep the `mode` question but frame it as Continue/Switch:

```json
{ "id": "mode", "prompt": "Continue in Scorecard mode?", "allowMultiple": false,
  "options": [
    { "id": "scorecard", "label": "Continue — Scorecard (Y/P/N)" },
    { "id": "conversation", "label": "Switch to Conversation" }
  ] }
```

(Swap labels for the conversation redirect.) Omit this question only if the manager already stated the mode in the same message.

---

## 2. Competency workspace-scan pick (Step 1, if `competency = file` and scan finds candidates)

```json
{
  "title": "Competency sheet",
  "questions": [
    { "id": "competency_file", "prompt": "Use one of these detected files?", "allowMultiple": false,
      "options": [
        { "id": "path::<detected-path-1>", "label": "<detected-path-1>" },
        { "id": "path::<detected-path-2>", "label": "<detected-path-2>" },
        { "id": "none", "label": "None of these — I'll give a path" }
      ] }
  ]
}
```

If `none`, collect the path as freeform text.

---

## 3. Mapping confirm (Step 1, after normalizing a provided sheet)

```json
{
  "title": "Confirm competency mapping",
  "questions": [
    { "id": "mapping_confirm", "prompt": "Sheet <name> · archetype <A/B/C/Flat> · level <resolved> · <N> areas / ~<M> prompts. Does this match how you think about this person's level and track?", "allowMultiple": false,
      "options": [
        { "id": "confirm", "label": "Yes — proceed" },
        { "id": "adjust", "label": "No — adjust level/track/mapping" }
      ] }
  ]
}
```

If `adjust`, gather the correction (level pick below or freeform) and re-confirm with the same call.

---

## 4. Level pick if ambiguous (Step 1/2, when sheet labels differ, e.g. L3 ↔ SE1, or multiple tracks/sheets)

```json
{
  "title": "Resolve level / track",
  "questions": [
    { "id": "level_pick", "prompt": "Which level/designation applies?", "allowMultiple": false,
      "options": [
        { "id": "<code-1>", "label": "<e.g. L3 / SE1>" },
        { "id": "<code-2>", "label": "<e.g. L4 / SE2>" }
      ] },
    { "id": "track_pick", "prompt": "Which track/sheet applies?", "allowMultiple": false,
      "options": [
        { "id": "<track-1>", "label": "<e.g. Devs>" },
        { "id": "<track-2>", "label": "<e.g. QA>" }
      ] }
  ]
}
```

Include the `track_pick` question only when the workbook has multiple role tracks. Options are built from the actual sheet.

---

## 5. Batch-entry opt-in (Step 3b, scorecard only)

```json
{
  "title": "Answer entry style",
  "questions": [
    { "id": "batch_entry", "prompt": "How do you want to enter scorecard answers?", "allowMultiple": false,
      "options": [
        { "id": "guided", "label": "Guided — click Y/P/N per pillar (recommended)" },
        { "id": "compact", "label": "Compact — I'll type a run-string like 1-10: YPYY…" }
      ] }
  ]
}
```

Only if `compact` may the manager type a run-string in chat afterward. `guided` → use the per-pillar/per-item `AskQuestion` calls below.

---

## 6. Phase B yes/no (Step 3a & 3b — promotion / next-level readiness)

```json
{
  "title": "Promotion / readiness pass",
  "questions": [
    { "id": "phase_b", "prompt": "Also assess against the next-level (promotion/PSE/EM) bar this cycle?", "allowMultiple": false,
      "options": [
        { "id": "yes", "label": "Yes — add a separate next-level pass" },
        { "id": "no", "label": "No — current-level performance only" }
      ] }
  ]
}
```

---

## 7. Pillar gate Y/P/N (Step 3b, scorecard — per CompetencyArea)

```json
{
  "title": "<Pillar name>",
  "questions": [
    { "id": "gate::<pillar-slug>", "prompt": "Overall for <Pillar name> at this level:", "allowMultiple": false,
      "options": [
        { "id": "Y", "label": "Y — meets/exceeds the bar" },
        { "id": "P", "label": "P — partially meets" },
        { "id": "N", "label": "N — does not meet" }
      ] }
  ]
}
```

Batch several pillar gates into one call when running the coarse four-pillar mode (one `gate::<slug>` question per pillar).

---

## 8. Skip-vs-score-anyway (Step 3b, after a pillar gate answers `Y`)

```json
{
  "title": "<Pillar name> — line items",
  "questions": [
    { "id": "skip_or_score::<pillar-slug>", "prompt": "Pillar gated Y. Score individual line items or skip them (Sampling)?", "allowMultiple": false,
      "options": [
        { "id": "skip", "label": "Skip line items — mark Sampling" },
        { "id": "score", "label": "Score anyway — go item by item" }
      ] }
  ]
}
```

---

## 9. Each scorecard item — Y/P/N (Step 3b) — batch one pillar's items per call

For a pillar with items, emit **one** `AskQuestion` call with one question per item (e.g. 5 items = 5 questions):

```json
{
  "title": "<Pillar name> — items",
  "questions": [
    { "id": "item::<pillar-slug>::1", "prompt": "<atomic prompt 1>", "allowMultiple": false,
      "options": [
        { "id": "Y", "label": "Y" }, { "id": "P", "label": "P" }, { "id": "N", "label": "N" }
      ] },
    { "id": "item::<pillar-slug>::2", "prompt": "<atomic prompt 2>", "allowMultiple": false,
      "options": [
        { "id": "Y", "label": "Y" }, { "id": "P", "label": "P" }, { "id": "N", "label": "N" }
      ] }
  ]
}
```

Repeat per pillar. If items are tagged current vs next-level, keep Phase A and Phase B in separate calls/sections.

---

## 10. Stick or revise (coach-light, both modes)

```json
{
  "title": "Stick or revise",
  "questions": [
    { "id": "stick_revise::<area-slug>", "prompt": "This reads more like 'meets the bar' than 'exceeds'. Stick with your read or revise?", "allowMultiple": false,
      "options": [
        { "id": "stick", "label": "Stick — my read stands" },
        { "id": "revise", "label": "Revise — adjust it" }
      ] }
  ]
}
```

One nudge per item, then move on.

---

## 11. Potential — six Y/N (both modes) — one batched call

```json
{
  "title": "Potential (future growth velocity)",
  "questions": [
    { "id": "pot::1", "prompt": "Acquires new skills noticeably faster than peers at the same level?", "allowMultiple": false, "options": [ {"id":"Y","label":"Yes"}, {"id":"N","label":"No"} ] },
    { "id": "pot::2", "prompt": "Has taken on progressively larger or more complex work this year?", "allowMultiple": false, "options": [ {"id":"Y","label":"Yes"}, {"id":"N","label":"No"} ] },
    { "id": "pot::3", "prompt": "Self-directs their learning without needing significant guidance?", "allowMultiple": false, "options": [ {"id":"Y","label":"Yes"}, {"id":"N","label":"No"} ] },
    { "id": "pot::4", "prompt": "Operates at the next level at least occasionally?", "allowMultiple": false, "options": [ {"id":"Y","label":"Yes"}, {"id":"N","label":"No"} ] },
    { "id": "pot::5", "prompt": "Could be ready for next-level responsibilities within 12 months?", "allowMultiple": false, "options": [ {"id":"Y","label":"Yes"}, {"id":"N","label":"No"} ] },
    { "id": "pot::6", "prompt": "Proactively seeks feedback and acts on it?", "allowMultiple": false, "options": [ {"id":"Y","label":"Yes"}, {"id":"N","label":"No"} ] }
  ]
}
```

Apply coach-light (ask for one example) on any Yes that pushes potential toward High.

---

## 12. Performance rating confirm (conversation mode)

```json
{
  "title": "Performance rating",
  "questions": [
    { "id": "rating_confirm", "prompt": "Based on what you described, a <N>/5 (<label>) fits. Confirm or adjust?", "allowMultiple": false,
      "options": [
        { "id": "confirm", "label": "Confirm <N>/5" },
        { "id": "up", "label": "Higher" },
        { "id": "down", "label": "Lower" }
      ] }
  ]
}
```

If `up`/`down`, propose the adjacent score and re-confirm with the same call shape.

---

## 13. Potential level confirm — High/Mid/Low (conversation mode)

```json
{
  "title": "Potential",
  "questions": [
    { "id": "potential_confirm", "prompt": "Trajectory reads as <High/Mid/Low>. Confirm or adjust?", "allowMultiple": false,
      "options": [
        { "id": "high", "label": "High" },
        { "id": "mid", "label": "Mid" },
        { "id": "low", "label": "Low" }
      ] }
  ]
}
```

---

## 14. Cross-report calibration yes/no (Synthesize step)

Only when `reports/` already holds other reviews for the same period.

```json
{
  "title": "Cross-report calibration",
  "questions": [
    { "id": "calibration", "prompt": "Other reviews exist for this period. Add a one-paragraph cross-report calibration note?", "allowMultiple": false,
      "options": [
        { "id": "yes", "label": "Yes — add calibration note" },
        { "id": "no", "label": "No — skip" }
      ] }
  ]
}
```

---

## 15. Auth-retry yes/no (Step 2b, when an MCP source is `needsAuth`)

```json
{
  "title": "Evidence source authentication",
  "questions": [
    { "id": "auth_retry::<source>", "prompt": "<Source> isn't authenticated. Authenticate in the IDE and retry, or continue without it?", "allowMultiple": false,
      "options": [
        { "id": "retry", "label": "I've authenticated — retry <source>" },
        { "id": "skip", "label": "Continue without <source>" }
      ] }
  ]
}
```

Evidence is soft; either answer lets the review proceed.

---

## Coverage checklist

Setup (mode · self-assessment · evidence · competency) · competency file pick · mapping confirm · level/track pick · batch-entry opt-in · Phase B yes/no · pillar gate Y/P/N · skip-vs-score-anyway · each scorecard item (batched per pillar) · six potential Y/N · stick/revise · performance rating confirm (conversation) · potential High/Mid/Low confirm (conversation) · cross-report calibration yes/no · auth-retry yes/no. Every one uses `AskQuestion` when available, or the **same catalog payload** in text-fallback after the mandatory warning.
