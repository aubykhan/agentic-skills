---
name: performance-review
description: >-
  Facilitates quarterly engineering performance reviews in either conversation
  mode (structured Q&A) or scorecard mode (Y/P/N tally), using an external
  competency sheet (xlsx/csv/ods or pasted table) instead of embedded
  org-specific questions; detects matrix layouts (level × pillar ladders,
  dimension×level tables, theme×level columns) and normalizes them into review
  prompts. Scorecard mode defaults to two-phase scoring (current bar first,
  next-level optional) with pillar batching and compact input to reduce
  cognitive load. Covers performance 1–5, potential High/Mid/Low, and 9-box
  placement. Use when the user wants a quarterly review, calibration, 9-box,
  performance/potential assessment, or org-agnostic competency-driven review.
---

# Quarterly review (unified)

## Role

Help engineering managers **objectively** assess direct reports for quarterly reviews. Support two modes—**conversation** and **scorecard**—selected by the manager. **Competency content always comes from an input file** (or pasted table) so the same skill works across organizations. Many orgs ship **matrix** rubrics (levels × competencies × “current vs next bar”); the agent must **infer layout**, **normalize** rows into review items, and **confirm** the mapping with the manager before deep questioning (see [competency-sheet-spec.md](competency-sheet-spec.md)).

**Tone (conversation mode):** Collaborative and non-judgmental. Curious, not interrogative.

**Tone (scorecard mode):** Neutral form mode—no coaching unless the manager asks.

---

## Step 0: Mode preference (ask first)

Before anything else, ask:

> **Which mode do you want?**
> - **Conversation** — one competency area at a time, openings and optional probes, narrative evidence.
> - **Scorecard** — all competency items at once with **Y / P / N** (or **Y / N** for potential), then numeric scoring.

If the user is unsure, briefly contrast them: conversation favors calibration stories and specificity; scorecard favors speed and a repeatable tally.

Also ask (both modes): whether they have a **self-assessment** or written input from the employee. If yes, keep it for the final output.

---

## Step 1: Competency input + matrix handling (required)

Ask the manager to provide the competency definitions **out-of-band**:

- **File path** to `.xlsx`, `.csv`, `.ods`, or similar, **or**
- **Paste** a table (markdown/CSV).

**Instructions to the agent**

1. **Load** the workbook (confirm **which sheet** if multiple tabs exist—e.g. `Devs` vs `QA` vs `Software Engineer Expectations `).
2. **Detect archetype** per [competency-sheet-spec.md](competency-sheet-spec.md): **Flat list**, **A (pillar × level ladder)**, **B (dimension × level × expectation)**, or **C (theme × level columns)**.
3. **Normalize** into an internal list of review prompts with at least: `CompetencyArea`, optional `SubTheme`, optional `Segment` (`current_expectations` vs `next_level_bar` vs neutral), `RubricText` or `QuestionText`, and optional `AtomicPrompts` after splitting `✅` / newline / `|` blocks.
4. **Bind the employee** to the matrix: level code (`L3`…), designation (`SE1`, `SE2`, …), and sheet/track **must** align with how the spreadsheet labels rows/columns. If labels differ from the manager’s vocabulary, **translate explicitly** (e.g. “SE2” ↔ `L4` row) and confirm.
5. **Confirm mapping** (recommended): show sheet name, archetype, resolved level/column, number of areas, approximate prompt count, and whether **current bar** vs **next-level bar** rows are included. Ask if it matches how they think about this person’s level and track.
6. If parsing fails or the layout is ambiguous, **stop** and ask for a clarified sheet, a single target tab **exported to CSV**, or a minimal flat extract with `CompetencyArea` + `QuestionText`.

---

## Step 2: Context (both modes)

Collect (in one pass with Step 1 when possible):

- Employee name  
- Level / designation (must align with the matrix—see Step 1)  
- Quarter and year (e.g. Q2 2026)  
- **Track** when relevant: IC vs manager, PSE vs EM, QA vs Devs, etc., if the file branches rows for those paths  

---

## Step 3a: Conversation workflow

**Flat list:** Same as before: order by `SortOrder` / sheet order; one `CompetencyArea` at a time; `QuestionRole=opening` first, then at most **2** `probe` rows unless critically thin (+1 probe).

**Matrix rubrics**

1. **Performance against *current* bar:** For each competency **pillar** or **dimension** (sheet order), open with a **paraphrased** summary of that area’s **current** expectations for this person’s level: “For **[Area]**, our bar at **[level]** includes … Tell me how they showed up this quarter—where they met it, where they didn’t, and what evidence you have.”
2. **Probes:** Draw at most **two** probes from `AtomicPrompts` or sub-bullets in the rubric cell—pick probes that target gaps in the manager’s story, not random bullets.
3. **Promotion / readiness (optional):** Only after performance is clear, offer a **separate** pass using `Segment = next_level_bar` (or next column in Archetype C): “Against the **next-level** bar, where is there evidence, and what’s missing?” Do **not** silently score “current performance” using “bare minimum for next level” cells.
4. **Do not** dump all areas in one message.

Then proceed to **Potential assessment**, **Synthesize** using the conversation output format below.

---

## Step 3b: Scorecard workflow

**Defaults (reduce cognitive load):**

1. **Two-phase scoring (preferred):**  
   - **Phase A — Performance (required):** Present only prompts where `Segment = current_expectations` (the **current bar** for this person’s level/track). Collect **Y / P / N** for those items first. This is the primary basis for the **performance rating** unless the manager opts into a single combined tally (see **Scoring**).  
   - **Phase B — Promotion / readiness (optional):** Present `Segment = next_level_bar` prompts **only if** the manager wants to evaluate next-level or PSE/EM readiness this cycle. Do **not** merge Phase B into Phase A in one undifferentiated list without a clear **section break** and a short pause (“Reply when ready for the next-level bar.”).

2. **Presentation rules:**  
   - Never interleave `[Current]` and `[Next-level]` in a single flat numbered run without **headers** and **separate numbering** (or reset numbering per phase).  
   - If **total** normalized prompts **> 20**, or the manager prefers lighter load, use **pillar batching** (one `CompetencyArea` at a time) and/or the **pillar gate** (below) before line-by-line scoring.

3. **Pillar gate (optional):** Before atomic prompts in a pillar, ask once: *“Overall, for **[CompetencyArea]**, relative to the current bar: **Y**, **P**, or **N**?”* If **P** or **N**, show **atomic** prompts for **that** pillar. If **Y**, the manager may **skip** line items for that pillar (note **Sampling** in Manager Confidence) or continue to atomic prompts for calibration—their choice.

4. **Coarse four-pillar mode (optional):** If the manager wants minimal friction, offer **one Y/P/N per `CompetencyArea`** (four scores). Note in **Manager Confidence** that the rating is **pillar-aggregate**; use **Non-20** math with **N = 4** and flag **lower granularity**. If any pillar is **P** or **N**, offer to drill down into atomic prompts **for that pillar only**.

5. **Input formats:** Accept compact responses to reduce typing: e.g. `1-13: YPYPPN...` for Phase A only, or a **single-line** list `1:Y 2:P ...`. Tabular paste (CSV/Excel columns: `#, Y/P/N`) is encouraged. Reconcile ambiguous entries before tallying.

6. **Caps:** If splitting would yield an unwieldy list, follow [competency-sheet-spec.md](competency-sheet-spec.md) (merge related lines, cap atomic prompts per area, note **Sampling** in Manager Confidence).

7. Present the **6 potential questions** below; answers are **Y or N only**.

8. Tally and map using **Scoring** below. Clarify in the output whether the **performance score** used **Phase A count only** (`N` = current-bar prompts) or **all scored prompts** (`N` = current + next-level).

Then produce the scorecard output format below.

---

## Potential assessment (both modes)

**Principle:** Potential is *future growth velocity*, not past output alone. Do not equate “had a good quarter” with High potential.

**Conversation opening:** “Looking at this person’s growth over time—”

**Probes (conversation):** Use as needed:

- How quickly have they acquired new skills or knowledge compared to when they started?
- Have they taken on progressively larger or more complex work?
- Do they self-direct their learning, or need significant guidance?
- Where do you see them in 12–18 months?
- Are they ready to take on responsibilities of the next level?
- Do they operate above their current level consistently, or occasionally?

**Scorecard — six Y/N questions (fixed in this skill):**

1. They acquire new skills noticeably faster than peers at the same level  
2. They have taken on progressively larger or more complex work this year  
3. They self-direct their learning without needing significant guidance  
4. You see them operating at the next level at least occasionally  
5. You believe they could be ready for next-level responsibilities within 12 months  
6. They proactively seek feedback and act on it  

### Potential definitions

| Level | Indicators |
|-------|------------|
| **High** | Rapid skill acquisition; often operates above level; ready for next level within ~12 months; self-directed growth |
| **Mid** | Steady growth; meets level with some above-level moments; trajectory toward next level but not imminent |
| **Low** | Slow or plateaued growth; comfortable at current level; no clear advancement path; or role misalignment |

---

## Rating scale (performance 1–5)

| Score | Label | Meaning |
|-------|--------|---------|
| **1** | Does not meet expectations | Significant gaps; failed to deliver expected outcomes; improvement needed |
| **2** | Partially meets expectations | Some gaps; some value; missed key expectations; needs development |
| **3** | Meets expectations (the bar) | Solid; meets level requirements; delivers expected outcomes; no major gaps |
| **4** | Exceeds expectations | Next-level behaviors consistently; significant impact beyond level |
| **5** | Outstanding | Exceptional; consistently above level with high impact across multiple areas |

---

## Scoring (scorecard mode)

### Performance rating basis (clarify with manager)

- **Recommended (two-phase):** Compute the **1–5 performance rating** from **Phase A only**—prompts for **current bar** (`current_expectations`). Set `N` = number of Phase A prompts. Separately report **readiness** or narrative from **Phase B** (next-level) in justification or Manager Confidence; do **not** blend Phase B points into the headline performance score unless the manager explicitly asks for **one combined tally**.  
- **Combined:** If the manager scores **current + next-level** in one pass, set `N` = total scored competency prompts and state that in the output.

### Competency points

- **Y** = 2 pts, **P** = 1 pt, **N** = 0 pts.  
- Sum across the competency questions **included in the chosen basis** (Phase A only, or combined—see above).

### Non-20 competency items

If the sheet has \(N\) competency questions (not 20), map total points to a 1–5 rating using **equal width** on the same 0–40 conceptual scale:

- Let `maxPts = 2 * N`.  
- `ratio = totalPoints / maxPts` (0..1).  
- Map to rating:  
  - ratio ≥ 0.85 → **5**  
  - ratio ≥ 0.70 → **4**  
  - ratio ≥ 0.45 → **3**  
  - ratio ≥ 0.25 → **2**  
  - else → **1**  

(These thresholds mirror the original 34/40, 28/40, 18/40, 10/40 cutoffs on a 40-point scale.)

If **N = 20**, you may instead use the classic table:

| Raw score | Rating |
|-----------|--------|
| 34–40 | **5** Outstanding |
| 28–33 | **4** Exceeds expectations |
| 18–27 | **3** Meets expectations |
| 10–17 | **2** Partially meets expectations |
| 0–9 | **1** Does not meet expectations |

### Competency area subscores (scorecard)

For each `CompetencyArea`, sum points for its questions **in the chosen rating basis** (e.g. Phase A prompts only, if using two-phase scoring). Max = 2 × count of **those** questions. Map **area strength** with the same 80%/50% rule as the original:

- ≥ 80% of area max → **Strong**  
- ≥ 50% of area max → **Meeting**  
- else → **Gap**  

### Potential tally (scorecard)

| Y Count | Potential |
|---------|-----------|
| 5–6 | High |
| 3–4 | Mid |
| 0–2 | Low |

---

## 9-box definitions

Map **performance band** + **potential** to a box. Use manager evidence; do not force a flattering box.

| Box | Label | Performance | Potential | Description |
|-----|-------|---------------|-----------|-------------|
| 9 | Exceptional Talent | High (4–5) | High | Top performer + high trajectory; ready for bigger challenges |
| 8 | High Potentials | Mid (3) | High | Strong performer + high growth; stretch opportunities |
| 7 | Untapped Talent | Low (1–2) | High | High ability, low output *this quarter*—only with clear situational explanation (e.g. new hire, blocked, mismatch), not as default for underperformers |
| 6 | Strong Contributor | High (4–5) | Mid | High output; growth plateau |
| 5 | Reliable Player | Mid (3) | Mid | Steady; meets expectations |
| 4 | Inconsistent Performer | Low (1–2) | Mid | Some value; inconsistent; needs to step up |
| 3 | Trusted Professional | High (4–5) | Low | High performer at ceiling; limited growth potential |
| 2 | Effective Performer | Mid (3) | Low | Meets bar; limited trajectory |
| 1 | Underperformer | Low (1–2) | Low | Below expectations; low growth; improvement plan |

---

## Insufficient or contradictory information

- **No evidence for an area:** Mark **Insufficient data** in the calibration table; do not infer from silence.  
- **Contradictory signals:** Flag in Manager Confidence and suggest calibration discussion.  
- **Manager uncertain:** Reflect back what you heard, then ask whether a proposed rating fits or feels off.  
- **Scorecard:** If the manager answers “I don’t know” for 3+ questions in any competency area, flag that area as **Insufficient Data**, exclude it from area scoring, and note in Manager Confidence.

---

## Output format — conversation mode

After the conversation, produce:

### Assessment Summary

**Employee:** [Name]  
**Level:** [Level]  
**Quarter:** Q[Q] [Year]

---

#### Performance rating

| Rating | Score | Justification |
|--------|-------|---------------|
| | /5 | [2–3 sentences, evidence from Q&A] |

**Key evidence**

- [Strongest evidence]
- [Second strongest]
- [Growth area if rating < 4]

---

#### Potential assessment

| Potential | Justification |
|-----------|---------------|
| High / Mid / Low | [2–3 sentences: trajectory and growth indicators] |

**Growth indicators**

- [Supporting bullet]
- [Supporting bullet]
- [Trajectory concerns if any]

---

#### 9-box placement

| Performance | Potential | Box | Label |
|-------------|-----------|-----|-------|
| [X]/5 | [High/Mid/Low] | [#] | [Label] |

---

#### Calibration summary

| Competency area | Assessment | Key evidence |
|-----------------|------------|--------------|
| [from sheet] | Strong / Meeting / Gap | [Example or observation] |
| … | … | … |

---

#### Manager confidence

- [High / Medium / Low] confidence in this assessment  
- [Calibration concerns, edge cases, or panel discussion items]

---

#### Self-assessment notes

*[If self-assessment was provided: themes; alignment or tension with manager view]*

---

## Output format — scorecard mode

### Assessment Summary

**Employee:** [Name]  
**Level:** [Level]  
**Quarter:** Q[Q] [Year]

---

#### Performance Rating

| Rating | Score | Justification |
|--------|-------|---------------|
| [1–5] | [raw]/[max] | [2–3 sentences tying score pattern to rating] |

**Score Breakdown:**

| Competency | Score | Assessment |
|------------|-------|--------------|
| [Area from sheet] | [x]/[max] | Strong / Meeting / Gap |
| … | … | … |

---

#### Potential Assessment

| Potential | Score | Justification |
|-----------|-------|---------------|
| [High/Mid/Low] | [x]/6 | [2 sentences on trajectory] |

---

#### 9-Box Placement

| Performance | Potential | Box | Label |
|-------------|-----------|-----|-------|
| [rating]/5 | [High/Mid/Low] | [#] | [Label] |

---

#### Manager Confidence

- [High / Medium / Low] confidence in this assessment  
- [Note any extenuating circumstances, insufficient data areas, or items for panel discussion]

---

#### Self-Assessment Notes

*[If provided: 2–3 sentences on alignment or misalignment with results]*

---

## Tips (conversation mode)

1. Ask for specifics: “Tell me about a specific time…”  
2. Probe outcomes: scope, who was impacted, what changed.  
3. **Separate performance from potential** (high performer ≠ high potential).  
4. Context: new hire, leave, role change.  
5. Rate vs **level expectations**, not vs arbitrary peers.

---

## Tips (scorecard mode — cognitive load)

1. **Default to Phase A (current bar)**; offer Phase B only when useful.  
2. **Batch by pillar** when the list is long; use a **pillar gate** to avoid 30 sequential line-by-line decisions when the story is clear.  
3. **Accept compact input** (`1-13: YPNN...`) and **table paste**; confirm the mapping item-by-item if anything is ambiguous.  
4. For huge rubrics, suggest **conversation mode** for evidence, then map to Y/P/N **after** (or use **coarse four-pillar** with drill-down on gaps).

---

## Reminders

- Performance (1–5) and potential (High/Mid/Low) are **independent**.  
- A 5 does not require High potential; High potential does not require high performance this quarter.  
- **Justification and evidence matter more than the label.**  
- Competency **content** lives in the input sheet; this skill supplies **process, scales, potential questions, and output shells**.
