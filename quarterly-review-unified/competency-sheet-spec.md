# Competency sheet format (input file)

> **Fallback:** when the manager provides **no** sheet and wants speed, use [default-rubric.md](default-rubric.md) (built-in SWE→PSE competency questions) instead of this spec. This file governs how to handle a **provided** sheet or pasted table.

Spreadsheets may be a **flat list** of questions *or* a **matrix** (levels × competencies × row types). The agent must **detect the layout**, **normalize** it into review items, **confirm** the mapping with the manager via an **`AskQuestion`** tool call (never a chat prompt), then run conversation or scorecard mode.

---

## 1. Flat list (baseline)

| Column | Required | Description |
|--------|----------|-------------|
| `CompetencyArea` | **Yes** | Area name for grouping and calibration. |
| `QuestionText` | **Yes** | Question or behavior statement. |
| `Level` | Optional | Filter to the employee’s level. |
| `QuestionRole` | Optional | `opening` / `probe` for conversation mode (first in group vs follow-up). |
| `SortOrder` | Optional | Stable ordering within an area. |

---

## 2. Matrix archetypes (dynamic)

Use these **detection heuristics** on the loaded table(s). A workbook may contain multiple sheets (e.g. `Devs`, `QA`, `Software Engineer Expectations `); when the **role track** is unclear, resolve it via an **`AskQuestion`** track pick ([ask-question-catalog.md](ask-question-catalog.md) §4), not a chat prompt.

### Archetype A — *Pillar × level ladder* (e.g. `Devs`, `QA`)

**Typical shape**

- Header row includes: `Level`, `Designation` (or similar), then **pillar columns** such as `Technical Skills`, `Delivery`, `Feedback, Communication, Collaboration`, `Leadership & Strategic Impact`.
- **Block rows** per level: a row with `Level` set (e.g. `L3`) and designation (e.g. `SE1`), then one or more **continuation rows** where `Level` is blank but the same block continues.
- A **row-type** column (often column C) distinguishes:
  - **Current Level** — expectations at this level now.
  - **Bare Minimum for Next Level** (sometimes suffixed ` - PSE track`, ` - EM track`) — promotion / readiness bar.

**Detection:** `Level` + `Designation` present **and** multiple pillar columns with long narrative cells.

**Normalize**

1. Walk rows top-to-bottom; carry forward `Level` / `Designation` when cells are blank (continuation rows).
2. For each `(Level, Designation, row-type)` block and each **pillar column**, create one **review item**:
   - `CompetencyArea` = pillar name.
   - `SubTheme` = optional: first line or `(i)…` label inside the cell.
   - `Segment` = `current_expectations` if row-type contains “Current”; `next_level_bar` if it contains “Bare Minimum” / “Next Level”; else `other`.
   - `RubricText` = full cell text.
   - `AtomicPrompts` = split cell into bullets (see **Splitting cells** below).

**How to run the review**

- **Conversation (performance):** For each pillar, use **only** `Segment = current_expectations` for the employee’s `(Level, Designation)` **unless** the manager wants to discuss promotion readiness (then add `next_level_bar` as a second pass or explicit section).
- **Conversation (readiness / promo):** Optional section: compare evidence against `next_level_bar` items for the **next** block or the row-type that matches “Bare Minimum…”.
- **Scorecard:** Each `AtomicPrompt` (or whole `RubricText` if you keep cells intact) = one **Y / P / N** line under `CompetencyArea` + optional tag `[Current bar]` / `[Next-level bar]`.

---

### Archetype B — *Dimension × level × single expectation* (e.g. `Software Engineer Expectations `)

**Typical shape**

- Columns: `Dimension` (or first column = competency area), `Level` (`L3`…`L8`), `Expectation` (short statement).

**Detection:** Three columns, repeated `Dimension` values with different `Level` rows.

**Normalize**

- Filter rows where `Level` matches the employee’s level (normalize `L3` ↔ `SE1` if the manager maps them — when labels differ, resolve via an **`AskQuestion`** level pick, [ask-question-catalog.md](ask-question-catalog.md) §4, not a chat prompt).
- One row per `Dimension` → `CompetencyArea` = Dimension, `QuestionText` = Expectation, `QuestionRole` = `opening` (probes optional: split Expectation into clauses or ask manager for examples).

---

### Archetype C — *Theme × level columns* (e.g. `Sheet1` — Engineering Competency Matrix)

**Typical shape**

- Left side: `Key Areas` / `Attribute` / `Theme` (or similar hierarchy).
- **Multiple columns** whose headers are **level names** (`SE1`, `SE2`, `E1`, `E2`, …).
- Cell = behavioral descriptor for that theme **at that level**.

**Detection:** Two or more columns that look like level labels; many rows with shared “Key Area” groups.

**Normalize**

1. Identify the **column** whose header best matches the employee’s current level (case-insensitive; confirm with manager if multiple tracks).
2. For each **data row** with non-empty text in that column:
   - `CompetencyArea` = leftmost non-empty of Key Area / big bucket column, or first column of the hierarchy.
   - `SubTheme` = `Theme` column or attribute.
   - `QuestionText` = the cell for the selected level (this is the rubric line).
3. **Optional roll-up:** Rows can be **grouped** by `CompetencyArea` for conversation (one opening per area summarizing themes), or asked **theme-by-theme** for granularity.

---

## 3. Splitting cells (ladder & long rubrics)

Many matrix cells bundle several behaviors. Split when useful:

| Pattern | Treatment |
|---------|-----------|
| Lines starting with `✅` | Each = one **atomic** scorecard prompt (strip emoji). |
| Numbered / `(i)` clauses | Optional atomic prompts, or one probe per clause in conversation. |
| `\|` or newlines | Often separates bullets—split into atomic prompts if scorecard needs finer granularity. |
| “n/a” | Skip or mark **Not applicable**; do not score. |

If splitting would explode into 50+ items, **cap** atomic items per pillar (e.g. 8–12) by merging related lines and note **Sampling** in Manager Confidence.

---

## 4. Mapping the employee to the matrix

Collect explicitly:

- **Level code** (`L3`, `L4`, …) **and/or** **designation** (`SE1`, `SE2`, `SSE1`, …).
- **Which sheet / track** (e.g. `Devs` vs `QA` vs `ML Engineer`) if the file has multiple — via **`AskQuestion`** ([ask-question-catalog.md](ask-question-catalog.md) §4) when more than one applies.

**Ambiguity:** If the sheet maps `L3 = SE1` in a comment cell, prefer the **designation** the manager uses day-to-day and verify against the sheet’s block for that row. When the level/designation is genuinely ambiguous, resolve it with an **`AskQuestion`** level pick (§4) — never a typed-reply chat menu.

---

## 5. Scorecard mode mapping (matrix)

- After normalization, each **atomic prompt** (or unsplit rubric line) is one **Y / P / N** row.
- Tag rows with `Segment` when present so calibration can separate **meeting current bar** vs **next-level bar**.
- **Rescaling:** Total points still use the skill’s proportional mapping from max points = `2 × N` where `N` = number of scored items (excluding n/a).

---

## 6. Conversation mode mapping (matrix)

- **Order:** Follow sheet order (top-to-bottom, then pillar order left-to-right) unless `SortOrder` exists.
- **Opening per area:** For Archetype A/C, synthesize one opening per `CompetencyArea`: “For **[Area]**, our **[level]** bar includes: [short paraphrase of current rubric]. Tell me how they showed up this quarter—where they met the bar, and where they didn’t.”
- **Probes:** At most **two** probes taken from `AtomicPrompts` or unparsed sub-bullets, chosen to fill gaps in the manager’s answer.
- **Promotion / readiness:** If the manager cares about promotion, add a dedicated subsection using `next_level_bar` items (Archetype A) or compare Archetype B/C to the **next** level column—**do not** conflate with performance against **current** bar unless the manager asks.

---

## 7. Confirmation step (required — via `AskQuestion`)

After detection + normalization, put the short **mapping summary** into the `prompt` of a **`AskQuestion`** confirm call ([ask-question-catalog.md](ask-question-catalog.md) §3). Do **not** print the summary and wait for a typed reply. Include:

- Sheet name + archetype (A/B/C or Flat)
- Resolved level column or `(Level, Designation)` row
- Count of competency areas and approximate prompt count

The `mapping_confirm` question offers **Yes — proceed** / **No — adjust**. On adjust, gather the correction (level/track pick §4 or freeform) and re-confirm with the same call before continuing.

---

## 8. File access

- Read `.xlsx` / `.ods` with appropriate libraries when available, or parse via unzip + XML if needed.
- `.csv` or pasted markdown tables: same normalization once rectangular data exists.
