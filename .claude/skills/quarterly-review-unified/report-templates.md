# Report templates

Full markdown report structures for both modes, plus the plain-form Record summary and optional Evidence / Promotion subsections. `SKILL.md` decides *when* to write; this file holds the *shells*.

> **Consistency:** Interactive choices are collected via **`AskQuestion`**, or **text-fallback with warning** if the tool was rejected ([interaction.md](interaction.md)). Log text-fallback in Manager Confidence when used.

## Rules (apply to every template)

- **Always write the file** to `reports/<employee-slug>-<YYYY-Qn>-quarterly-review.md` (slug: lowercase, hyphen-separated, ASCII; create `reports/` if missing). This is mandatory — even if the manager requests chat-only output. Echo the file path and a one-line confirmation in the same message; optionally echo the full report inline.
- **No question IDs in written output.** Never use `Q1`–`Q20`, `item 5`, `question 3`, or numbered potential prompts in any HR-facing text (Record summary, Assessment summary, Key evidence, Calibration, Manager confidence, Self-assessment notes). Refer to the **CompetencyArea** and the **substance** in plain language. Numbers are fine only when listing questions *to the manager* live.
- **Calibration summary:** one row per `CompetencyArea` from the normalized rubric (sheet order), not a fixed list of four pillars.
- **Insufficient data** where the manager gave no evidence — do not infer from silence.
- **Evidence subsection:** include only when MCP evidence materially shaped the assessment (see [evidence-mcp.md](evidence-mcp.md)). Otherwise log evidence status in Manager confidence only.
- **Promotion/readiness subsection:** include only when Phase B (next-level bar) was run. Report it **separately**; never blend into the headline performance score unless the manager explicitly asked for a combined tally.

---

## Record summary (plain form) — embedded in every report

Compact block for copy-paste into HR systems. Same facts as the assessment; short lines. `Level` is a single value — use the org's label as given (e.g. `SE2`, `SWE2`, `L4`). `Evaluation Date`: manager's stated date, else last calendar day of the quarter (Q1 Mar 31, Q2 Jun 30, Q3 Sep 30, Q4 Dec 31).

```
Name: [NAME]

Evaluation Period: [YYYY-Qn]
Level: [e.g. SE2]
Evaluation Date: [e.g. Mar 31, 2026]
Performance (1-5): [1–5]

Strengths:
- [bullet]
- [bullet]

Areas of Improvement:
- [bullet]
- [bullet]

Action Plan:
- [bullet]
- [bullet]

Remarks or Context:
[short paragraph or bullets, or —]
```

- **Strengths:** 2–5 bullets from **Strong** areas / key evidence / justification.
- **Areas of Improvement:** 2–5 bullets from **Gap** (and relevant **Meeting**) areas.
- **Action Plan:** 2–4 forward-looking, specific bullets tied to improvement areas.
- **Remarks or Context:** extenuating circumstances, calibration notes, or `—`.

---

## Optional subsections (both modes)

Insert these under **Assessment summary** when applicable.

### Evidence (optional — MCP)

```markdown
### Evidence reviewed

| Signal | Source | Bearing |
|--------|--------|---------|
| [summarized signal] | [PROJ-123 / #456 / page title / #channel, date] | Supports / Counters / Insufficient |
```

### Promotion / readiness (optional — Phase B)

```markdown
### Promotion / readiness (next-level bar)

*Reported separately from the headline performance rating.*

| Next-level area | Evidence | Gap to close |
|-----------------|----------|--------------|
| [area] | [what exists] | [what's missing] |

**Readiness read:** [1–2 sentences — e.g. "Approaching the SSE bar in Delivery; not yet in Leadership." Not a promotion decision.]
```

---

## Markdown report structure — Conversation

Set **Review mode** to `Conversation (qualitative)`. Do **not** invent numeric raw scores; performance is the manager's 1–5 judgment with narrative evidence vs the **current** bar (plus optional next-level pass).

```markdown
# Quarterly performance review report

| Field | Value |
|--------|--------|
| **Employee** | [Name] |
| **Level** | [Level or designation] |
| **Period** | Q[Q] [Year] (`YYYY-Qn`) |
| **Evaluation date** | [date, or last day of quarter] |
| **Review mode** | Conversation (qualitative) — *Y/P/N scorecard not used* |

---

## Record summary (plain form)

[filled plain-form block in a fenced code block]

---

## Assessment summary

### Performance rating

| Label | Score | Justification |
|--------|------|----------------|
| [Meets / Exceeds / …] | **1–5** / 5 | [2–3 sentences, evidence from Q&A vs current bar; mention next-level only if a separate pass was done] |

#### Key evidence

- [Strongest evidence]
- [Second strongest]
- [Growth area if rating < 5, or "Insufficient data" for thin areas]

[Optional: ### Evidence reviewed — if MCP evidence used]
[Optional: ### Promotion / readiness — if Phase B run]

---

### Potential assessment

| Potential | Justification |
|-----------|---------------|
| **High / Mid / Low** | [2–3 sentences: trajectory and growth, independent of "good quarter"] |

#### Growth indicators

- [Supporting bullet]
- [Supporting bullet]
- [Trajectory concerns if any]

---

### 9-box placement

| Performance band | Potential | Box | Label |
|------------------|-----------|-----|--------|
| [1–5] | **High / Mid / Low** | **#** | **Label** |

*Optional one-line calibration note (promotion timing, Box 7 caveat, cross-report calibration).*

---

### Calibration summary

| Competency area | Assessment | Key evidence |
|-----------------|-------------|--------------|
| [from sheet, row 1] | Strong / Meeting / Gap / Insufficient data | [Example or observation] |
| […] | … | … |

---

### Manager confidence

- [High / Medium / Low] confidence in this assessment
- Interaction: [AskQuestion UI | text fallback (AskQuestion unavailable — <brief platform error>)]
- Evidence: [sources used / declined / unauthenticated]
- [Calibration concerns, contradictory signals, panel items]

---

### Self-assessment notes

[If provided: themes; **alignment vs tension** with manager view. Else: *No employee self-assessment on file for this period.*]

---

## Employee self-assessment (raw input)

[If provided: paste bullets or short employee text. Else omit or: *— None provided.*]

---

## Document history

| Version | Date | Notes |
|---------|------|--------|
| 1.0 | [date] | Initial conversation review. |
```

---

## Markdown report structure — Scorecard

Set **Review mode** to `Scorecard (Y/P/N)`. **Raw points** = `totalPoints / maxPts`, `maxPts = 2 × N` for the chosen basis (Phase A only, or combined). Per-area max = `2 × prompts for that area in the basis`. Potential = Y count / 6.

```markdown
# Quarterly performance review report

| Field | Value |
|--------|--------|
| **Employee** | [Name] |
| **Level** | [Level or designation] |
| **Period** | Q[Q] [Year] (`YYYY-Qn`) |
| **Evaluation date** | [date, or last day of quarter] |
| **Review mode** | Scorecard (Y/P/N) |
| **Performance basis** | [Phase A (current bar) / Combined] — *state N; Phase B reported separately* |

---

## Record summary (plain form)

[filled plain-form block in a fenced code block]

---

## Assessment summary

### Performance rating

| Label | Score | Raw points | Justification |
|--------|-------|------------|---------------|
| [Meets / Exceeds / …] | **[1–5]** / 5 | **[totalPoints]** / **[maxPts]** | [2–3 sentences: tie band to Y/P/N pattern and CompetencyArea strengths/gaps; Phase B noted separately if used] |

#### Score breakdown

| Competency (from sheet) | Score | Assessment |
|-------------------------|-------|------------|
| [Area] | [areaPts]/[2×prompts in area, same basis] | Strong / Meeting / Gap |
| … | … | … |

#### Key evidence

- [Strongest Y-pattern or example — describe behavior]
- [P/N clusters driving gaps — by topic]

[Optional: ### Evidence reviewed — if MCP evidence used]
[Optional: ### Promotion / readiness — if Phase B run]

---

### Potential assessment

| Potential | Score | Justification |
|-----------|-------|---------------|
| **High / Mid / Low** | **[0–6]** / 6 (Y count) | [2 sentences: trajectory, independent of performance] |

#### Growth / trajectory notes

- [Learning velocity, scope growth, self-direction, next level]
- [Concerns or calibration items if any]

---

### 9-box placement

| Performance band | Potential | Box | Label |
|------------------|-----------|-----|--------|
| [1–5] | **High / Mid / Low** | **#** | **Label** |

*Optional one-line note (Box 7 caveat, cross-report calibration).*

---

### Calibration summary

| Competency area | Assessment | Key evidence |
|-----------------|-------------|--------------|
| [from sheet] | Strong / Meeting / Gap | [brief] |
| … | … | … |

---

### Manager confidence

- [High / Medium / Low] confidence in this assessment
- Interaction: [AskQuestion UI | text fallback (AskQuestion unavailable — <brief platform error>)]
- Evidence: [sources used / declined / unauthenticated]
- [Insufficient data, **Sampling** if line items skipped, panel items]

---

### Self-assessment notes

[If provided: **alignment vs tension** with the scorecard. Else: *No employee self-assessment on file for this period.*]

---

## Employee self-assessment (raw input)

[If provided: paste bullets or employee text. Else omit or: *— None provided.*]

---

## Document history

| Version | Date | Notes |
|---------|------|--------|
| 1.0 | [date] | Initial scorecard review. |
```

---

## Inline display

Always write the file. You may *also* echo the full report inline in the assistant message for convenience — but the file write is never optional and must happen regardless of the manager's preference.
