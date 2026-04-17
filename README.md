# agentic-skills

A collection of skill guides for facilitating quarterly engineering performance reviews. These skills help engineering managers assess direct reports objectively using structured conversation or scorecard modes with competency-based frameworks.

## Contents

### [performance-review.md](performance-review.md)
The primary unified guide for quarterly engineering performance reviews. Supports two modes:
- **Conversation Mode** — Structured Q&A with competency-level probes for narrative, calibration-ready evidence
- **Scorecard Mode** — Y/P/N tally format with compact input to reduce cognitive load

Detects and normalizes matrix layout rubrics (level × pillar × dimension) from external competency sheets (xlsx/csv/ods or pasted tables) into review prompts.

**Covers:** Performance rating (1–5), Potential assessment (High/Mid/Low), 9-box placement

### [performance-review-fixed-competencies.md](performance-review-fixed-competencies.md)
Conversation mode guide for structured quarterly reviews. Leads managers through:
- Competency-based Q&A (one area at a time)
- Level-specific assessment (SWE, SWE2, SSE, SSE2, PSE)
- Performance and potential rating
- 9-box grid placement
- Calibration-ready evidence collection

**Use when:** Manager wants a detailed, conversational review with evidence-based justification.

### [performance-review-fixed-competencies-quick.md](performance-review-fixed-competencies-quick.md)
Quick scorecard questionnaire for performance assessments. Presents all competency items at once and collects Y/P/N responses.

**Use when:** Manager wants fast, structured assessment with repeatable scoring (4 competencies × 5 questions = 40 pts → rating 1–5; 6 potential questions → High/Mid/Low)

---

## How to Use

1. Choose the appropriate skill based on your needs:
   - **Full guidance with matrix handling** → Use `performance-review.md`
   - **Conversational, evidence-focused** → Use `performance-review-fixed-competencies.md`
   - **Fast scorecard tally** → Use `performance-review-fixed-competencies-quick.md`
2. Provide employee information (name, level, quarter)
3. Follow the structured prompts to assess competencies
4. Review the generated output (evidence summary, ratings, 9-box placement)