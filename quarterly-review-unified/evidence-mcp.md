# Soft evidence via MCP

Optional, **soft** support: pull artifacts from Jira / Slack / Confluence / GitHub to back or counter the manager's claims. **Never hard-block a rating on evidence.** If sources are declined, unauthenticated, or return nothing, proceed on the manager's knowledge and log the status in **Manager Confidence**.

## Flow

1. **Offer** (Step 0b) via the setup **`AskQuestion`** multi-select (`allowMultiple: true`) — the `evidence` question in [ask-question-catalog.md](ask-question-catalog.md) §1. Never list sources in chat and ask for a typed reply. Options: Jira, Slack, Confluence, GitHub, Skip for now.
2. **Discover servers/tools.** For each selected source, use `GetMcpTools` to find a matching server and its tools *before* any call. Match loosely by name (e.g. a server whose id/tools mention `jira`, `slack`, `confluence`, `github`).
3. **Handle auth.** If a server's `serverStatus` is `needsAuth` (or `error`/`loading`), do **not** call it. If a `mcp_auth` tool is exposed, offer authenticate-and-retry vs continue-without via an **`AskQuestion`** call ([ask-question-catalog.md](ask-question-catalog.md) §15) — not a prose question. Note the source as *unauthenticated* if not retried, and continue the review either way.
4. **Query** the discovered tools (see per-source guidance). Always inspect a tool's schema via `GetMcpTools` before `CallMcpTool`.
5. **Build a brief dossier** (Step 2b): a short, per-source bullet summary presented before deep Q&A. Not the review itself — just signal to make the conversation/scorecard sharper.

Keep it lightweight: a few targeted queries per source, scoped to the employee and the quarter. Don't spider.

---

## What to query per source

| Source | Pull | Scope |
|--------|------|-------|
| **Jira** | Issues assigned to / completed by the employee; epics led; notable status changes | The review quarter only |
| **Slack** | **High-level activity themes only** — where they're active, recurring topics, help given/received | Themes, not message contents |
| **Confluence** | Design docs, RFCs, review notes, retros they authored or drove | The review quarter |
| **GitHub** | PRs merged and PRs reviewed; notable reviews/design discussions | The review quarter |

Resolve the employee's identity per source (Jira account, Slack user, GitHub handle) — ask the manager if ambiguous rather than guessing.

---

## How to use evidence

For each competency area or claim, evidence can:
- **Support** — corroborates the manager's rating (e.g. "3 epics led in Jira" supports strong Delivery).
- **Counter** — tension with the rating (e.g. "no design docs found" vs a strong Technical Skills claim). Surface gently, coach-light: note the gap and invite stick-or-revise. Never override the manager's judgment.
- **Insufficient signal** — nothing conclusive found. Say so plainly; do not treat absence as proof of a gap.

Evidence informs the conversation; the **manager's judgment sets the rating**.

---

## Privacy rules (required)

- **Summarize**, never paste raw content. No verbatim Slack messages, no confidential comment bodies, no private doc excerpts.
- **Cite by reference:** Jira ticket keys (`PROJ-123`), PR numbers (`#456`), Confluence page titles, Slack **channel + date** (e.g. `#eng-platform, 2026-05-12`).
- Slack is **themes only** — never quote or attribute individual messages.
- If in doubt whether something is confidential, summarize at a higher level or omit.

---

## What to write into the report

- **Manager Confidence** — always log evidence status: sources **used**, **declined**, or **unauthenticated/unavailable**. Example: *"Evidence: Jira + GitHub reviewed; Slack skipped; Confluence unauthenticated."*
- **Evidence section (optional)** — when evidence materially shaped the assessment, add the short Evidence subsection from [report-templates.md](report-templates.md): 3–6 bullets, each a summarized signal with its citation, tagged *supports* / *counters* / *insufficient*.
- Keep both concise. Evidence backs the narrative; it does not replace it.
