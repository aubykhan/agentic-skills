---
name: quarterly-review-unified
description: >-
  Facilitates quarterly engineering performance reviews in conversation mode
  (structured coach-light Q&A) or scorecard mode (Y/P/N tally), producing a
  performance rating (1–5), potential (High/Mid/Low), and 9-box placement with
  calibration-ready evidence. Uses an external competency sheet (xlsx/csv/ods or
  pasted table) or a built-in default rubric; detects and normalizes matrix
  layouts (level × pillar ladders, dimension×level, theme×level columns). Offers
  soft, optional MCP evidence (Jira, Slack, Confluence, GitHub) to back or
  counter claims. Prefers the native Cursor AskQuestion tool (blocking
  checkbox/radio UI) for every closed choice; if AskQuestion is rejected by the
  platform, falls back to text menus with a mandatory warning. Use when a
  manager wants a quarterly review, performance/potential assessment, 9-box,
  calibration, conversation or scorecard review, or a competency-driven review
  backed by real evidence.
---

# Quarterly review (unified)

Help engineering managers **objectively** assess direct reports. This is the **sole full implementation**; the `quarterly-review-conversation` and `quarterly-review-scorecard` skills are thin redirects that invoke this file with a mode preselected.

## First action (do this before anything else)

**The very first action MUST be an `AskQuestion` tool call** for batched setup (mode, self-assessment, evidence, competency — [ask-question-catalog.md](ask-question-catalog.md) §1). Emit it, **end your turn**, wait. Do **not** open with a chat menu.

If the platform **rejects** `AskQuestion` (tool not found / not permitted): enter **text-fallback** per [interaction.md](interaction.md) — print the **mandatory warning block**, then ask the same catalog questions as typed option-id menus. Log `Interaction: text fallback` in Manager Confidence. Do **not** skip the warning. Do **not** use Plan mode as recovery.

Two modes:
- **Conversation** — one competency area at a time, openings + probes, narrative evidence. Tone: curious, **coach-light**.
- **Scorecard** — Y/P/N per item, then numeric scoring. Tone: form-first, still **coach-light** on P/N and stretch Ys.

**Competency content comes from an input file or the default rubric** — this skill supplies process, scales, potential questions, and output shells.

## Supporting files (read as needed)

- [interaction.md](interaction.md) — AskQuestion first; text-fallback after tool rejection **with mandatory warning**; exact invocation.
- [ask-question-catalog.md](ask-question-catalog.md) — exact payloads (ids, prompts, options) for every closed choice — use with AskQuestion **or** the same ids in text-fallback.
- [evidence-mcp.md](evidence-mcp.md) — soft MCP evidence flow, per-source queries, privacy.
- [competency-sheet-spec.md](competency-sheet-spec.md) — detecting/normalizing sheets and matrices.
- [default-rubric.md](default-rubric.md) — built-in SWE→PSE competency questions (fallback when no sheet).
- [report-templates.md](report-templates.md) — full report structures + Record summary + optional Evidence/Promotion subsections.
- [scripts/ask-select.sh](scripts/ask-select.sh) / [scripts/ask-multi.sh](scripts/ask-multi.sh) — **CLI-only emergency** fzf TUI, used **only** if an `AskQuestion` call literally errors **and** the manager is in a headless CLI with a TTY. Never the default.

## Coach-light rules (apply throughout)

- Ask for **one concrete example** on every **P** and **N**, and on any **Y** that would push overall performance toward **4–5** or potential toward **High**.
- When a story sounds like "meets the bar" rather than "exceeds," gently note it and invite **stick or revise** (see [interaction.md](interaction.md)). Do **not** lecture or force a lower rating — the manager's judgment stands.
- Scorecard timing: ask for examples **after each pillar** (or after full Phase A), on N/P items and Strong-pushing Y clusters — not after every single line, which kills speed.
- One nudge per item, then move on.

---

## Workflow (early steps in order)

### Step 0 — Blocking setup UI (hard stop, first action)

**Read [interaction.md](interaction.md) and [ask-question-catalog.md](ask-question-catalog.md) first.**

1. Call **`AskQuestion`** with batched setup (catalog §1). Emit even if unsure it is listed.
2. **End your turn** after the tool call. Wait for the UI response.
3. If **rejected**: print the **mandatory AskQuestion-unavailable warning** ([interaction.md](interaction.md)), then present the **same** §1 questions as text option-id menus and continue the review in text-fallback for the session. Log it in Manager Confidence. Do **not** switch to Plan mode.
4. Redirect skills: mode may be preselected — confirm via `AskQuestion` (or text-fallback) Continue / Switch.

### Step 0b — Soft evidence sources

Collected via the Step 0 multi-select (Jira · Slack · Confluence · GitHub · Skip). Soft — never blocks. Pull in Step 2b if selected. See [evidence-mcp.md](evidence-mcp.md).

### Step 1 — Competency source

Chosen in Step 0 UI. If “file,” ask for the path (freeform — an open field). If “paste,” ask for the table (freeform). First, optionally scan the workspace for `*competenc*`, `*rubric*`, `*expectations*`, `*ladder*`, `*levels*`; if hits are found, present them as an `AskQuestion` single-select (catalog §2), never as a chat list.
- File/paste → load and normalize per [competency-sheet-spec.md](competency-sheet-spec.md): detect archetype (Flat / A / B / C), normalize to review items, bind level/track (if level/track is ambiguous, resolve via `AskQuestion` — catalog §4), **confirm mapping via `AskQuestion`** (catalog §3) before deep Q&A.
- Default rubric → [default-rubric.md](default-rubric.md) (20 items/level, 4 areas). No `next_level_bar` rows; Phase B is narrative-only unless the manager supplies next-level expectations.

### Step 2 — Context

Collect (batch with Step 1 where possible): employee **name**; **level/designation** (must align with the rubric/matrix); **quarter + year** (e.g. Q2 2026); **track** if the sheet branches (IC vs manager, QA vs Devs, PSE, etc.).

### Step 2b — Optional evidence pull

If sources were selected **and** MCP is available: discover tools (`GetMcpTools`) before any `CallMcpTool`, handle `needsAuth` gracefully (offer authenticate-and-retry vs continue-without via `AskQuestion` — catalog §15), query per source, and present a brief **dossier** before deep Q&A. Log evidence status regardless. See [evidence-mcp.md](evidence-mcp.md). Then continue to Step 3a or 3b by mode.

---

## Step 3a — Conversation workflow

Narrative **openings and probes stay freeform** — you invite the manager to tell the story in prose. But every **closed choice** inside conversation mode (stick/revise, Phase B offer, rating confirmation, potential-level confirmation) is an `AskQuestion` call.

- **Flat/default rubric:** one `CompetencyArea` at a time in sheet order; open with the area's `opening` (freeform), then at most **2** probes (only to fill gaps in the manager's story). Never dump all areas in one message.
- **Matrix rubrics:** for each pillar/dimension, open with a **paraphrased** summary of the **current** bar for this level: *"For [Area], our bar at [level] includes … Tell me how they showed up this quarter — where they met it, where they didn't, and your evidence."* Draw ≤2 probes from `AtomicPrompts`/sub-bullets targeting gaps.
- Apply **coach-light** on the fly: request an example on thin/stretch claims (freeform reply); gently flag "meets vs exceeds"; offer **stick-or-revise via `AskQuestion`** (catalog §10).
- **Promotion / readiness (optional):** offer the Phase B pass via **`AskQuestion`** (catalog §6). Only if Yes, and only after current-bar performance is clear, run a **separate** pass on `Segment = next_level_bar` (or the next-level column). Never score current performance using next-level cells.
- **Rating confirmation:** confirm the 1–5 performance rating via **`AskQuestion`** (catalog §12), not a prose "does 4/5 sound right?".

Then → **Potential** (confirm High/Mid/Low via **`AskQuestion`** — catalog §13), → **Synthesize**, → write report (Conversation structure in [report-templates.md](report-templates.md)).

## Step 3b — Scorecard workflow

Every Y/P/N and every Y/N in scorecard mode is an `AskQuestion` call. **Batch** where possible — e.g. one pillar's 5 items as 5 questions in a single `AskQuestion` call (catalog §9).

1. **Batch-entry opt-in:** offer guided (click Y/P/N) vs compact run-string via **`AskQuestion`** (catalog §5). Only `compact` permits a typed run-string later.
2. **Two-phase (preferred):**
   - **Phase A — Performance (required):** present only `current_expectations` prompts; collect **Y / P / N** via `AskQuestion`. Primary basis for the rating.
   - **Phase B — Promotion / readiness (optional):** offer via **`AskQuestion`** (catalog §6); present `next_level_bar` prompts only if Yes. Keep a clear section break / separate calls; never merge into Phase A undifferentiated.
3. **Presentation:** never interleave current and next-level in one flat run without headers/separate numbering. If normalized prompts **> 20** or the manager prefers lighter load, use **pillar batching** and/or the **pillar gate**.
4. **Pillar gate (optional):** per `CompetencyArea`, collect overall **Y/P/N** via **`AskQuestion`** (catalog §7). **Y** → follow-up **`AskQuestion`**: Skip line items (*Sampling*) or Score anyway (catalog §8). **P/N** → atomic prompts via batched **`AskQuestion`** (catalog §9).
5. **Coarse four-pillar mode (optional):** one Y/P/N per `CompetencyArea` via a single batched **`AskQuestion`** (catalog §7); note **pillar-aggregate**, Non-20 with `N = 4`; drill into any P/N pillar with more `AskQuestion` items.
6. **Compact input:** only after the batch-entry `AskQuestion` opt-in returned `compact` — then accept `1-13: YPYPPN…` / keyed lists / table paste. See [interaction.md](interaction.md).
7. **Coach-light:** after each pillar (or Phase A), examples on **N/P** and stretch **Y** clusters (freeform replies); stick-or-revise via **`AskQuestion`** (catalog §10).
8. **Potential:** six **Y/N** via one batched **`AskQuestion`** (catalog §11), never a chat letter dump.
9. Tally via **Scoring**. State Phase A only vs combined.

Then produce the Scorecard report structure in [report-templates.md](report-templates.md).

---

## Potential assessment (both modes)

**Principle:** potential is *future growth velocity*, not past output. A good quarter ≠ High potential.

**Conversation opening (freeform):** "Looking at this person's growth over time —" then probe as needed: skill-acquisition speed vs when they started; progressively larger/complex work; self-directed vs guided learning; where in 12–18 months; readiness for next level; operating above level consistently vs occasionally. Confirm the final **High/Mid/Low** via **`AskQuestion`** (catalog §13).

**Scorecard — six Y/N questions (fixed), asked as one batched `AskQuestion` (catalog §11):**

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

Apply **coach-light** to any answer pushing potential to **High**: ask for one concrete example.

---

## Rating scale (performance 1–5)

| Score | Label | Meaning |
|-------|--------|---------|
| **1** | Does not meet expectations | Significant gaps; failed to deliver expected outcomes |
| **2** | Partially meets expectations | Some gaps; missed key expectations; needs development |
| **3** | Meets expectations (the bar) | Solid; meets level requirements; no major gaps |
| **4** | Exceeds expectations | Next-level behaviors consistently; impact beyond level |
| **5** | Outstanding | Exceptional; consistently above level; high impact across areas |

---

## Scoring (scorecard mode)

**Performance basis (clarify with manager):**
- **Recommended (two-phase):** compute the 1–5 rating from **Phase A only** (`current_expectations`); `N` = number of Phase A prompts. Report Phase B (next-level) **separately** (readiness / Promotion subsection); never blend into the headline score unless the manager asks for one combined tally.
- **Combined:** if scoring current + next-level in one pass, set `N` = total scored prompts and state it.

**Competency points:** **Y** = 2, **P** = 1, **N** = 0. Sum across the prompts in the chosen basis.

**Non-20 mapping (equal-width on a 0–40 conceptual scale):** `maxPts = 2 × N`; `ratio = totalPoints / maxPts`:
- ≥ 0.85 → **5** · ≥ 0.70 → **4** · ≥ 0.45 → **3** · ≥ 0.25 → **2** · else → **1**

(Mirrors the classic 34/28/18/10-of-40 cutoffs.) If `N = 20`, the classic table is equivalent: 34–40 → 5, 28–33 → 4, 18–27 → 3, 10–17 → 2, 0–9 → 1.

**Area subscores:** per `CompetencyArea`, sum points for its prompts in the basis; max = `2 × count`. Map: ≥ 80% → **Strong**, ≥ 50% → **Meeting**, else → **Gap**.

**Potential tally:** Y count 5–6 → **High**, 3–4 → **Mid**, 0–2 → **Low**.

---

## 9-box definitions

Map **performance band** + **potential** to a box. Use manager evidence; do not force a flattering box.

| Box | Label | Performance | Potential | Description |
|-----|-------|-------------|-----------|-------------|
| 9 | Exceptional Talent | High (4–5) | High | Top performer + high trajectory; ready for bigger challenges |
| 8 | High Potentials | Mid (3) | High | Strong performer + high growth; stretch opportunities |
| 7 | Untapped Talent | Low (1–2) | High | High ability, low output *this quarter* — only with a clear situational reason (new hire, blocked, mismatch), not a default for underperformers |
| 6 | Strong Contributor | High (4–5) | Mid | High output; growth plateau |
| 5 | Reliable Player | Mid (3) | Mid | Steady; meets expectations |
| 4 | Inconsistent Performer | Low (1–2) | Mid | Some value; inconsistent; needs to step up |
| 3 | Trusted Professional | High (4–5) | Low | High performer at ceiling; limited growth |
| 2 | Effective Performer | Mid (3) | Low | Meets bar; limited trajectory |
| 1 | Underperformer | Low (1–2) | Low | Below expectations; low growth; improvement plan |

---

## Insufficient or contradictory information

- **No evidence for an area:** mark **Insufficient data** in calibration; do not infer from silence.
- **Contradictory signals** (incl. MCP evidence that counters a claim): flag in Manager Confidence; surface coach-light; suggest calibration discussion.
- **Manager uncertain:** reflect back what you heard, then ask whether a proposed rating fits.
- **Scorecard:** if the manager answers "I don't know" for 3+ prompts in an area, flag it **Insufficient Data**, exclude from area scoring, note in Manager Confidence.

---

## Step 4 — Synthesize & Export Report (hard stop — always runs)

**This step is mandatory. Do not skip or defer it. Chat-only output is never sufficient.**

1. Assemble the full markdown document using the matching structure in [report-templates.md](report-templates.md) (Conversation or Scorecard), including the plain-form **Record summary**.
2. **Write the file** to `reports/<employee-slug>-<YYYY-Qn>-quarterly-review.md` (create `reports/` if missing). Use slug format: lowercase, hyphen-separated, ASCII only.
3. **Echo the file path** and a one-line confirmation in the same chat message. Optionally echo the full report inline for readability.

If the manager says "no file" or "just show me in chat," still write the file. Acknowledge the request, write anyway, and confirm the path — the export is always required.

Report specifics handled in [report-templates.md](report-templates.md):
- **No question IDs** in any HR-facing text.
- Calibration = one row per `CompetencyArea` (sheet order).
- **Evidence subsection** (optional) when MCP evidence shaped the assessment; always log evidence status (used / declined / unauthenticated) in **Manager Confidence**.
- **Promotion/readiness subsection** (optional) when Phase B ran — separate from the headline rating.
- **Self-assessment notes:** call out **alignment vs tension** with the manager's view.

**Calibration (optional):** if `reports/` already holds other reviews for the same period, offer cross-report calibration yes/no via **`AskQuestion`** or text-fallback (catalog §14). Do not build a full panel UI.

---

## Reminders

- Performance (1–5) and potential (High/Mid/Low) are **independent**. A 5 doesn't require High potential; High potential doesn't require high performance this quarter.
- **Justification and evidence matter more than the label.**
- Competency **content** lives in the sheet/default rubric; this skill supplies **process, scales, potential questions, and output shells**.
- Evidence is **soft**: back or counter, never block. Summarize and cite — never paste raw content.
- **Closed choices:** prefer `AskQuestion`; if the platform rejects it, use **text-fallback with the mandatory warning** ([interaction.md](interaction.md)). Skipping the attempt or the warning is a defect. Catalog ids stay the same in both paths.
