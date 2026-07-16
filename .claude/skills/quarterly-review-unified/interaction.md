# Interaction — AskQuestion first; text fallback only after tool rejection

Every **closed choice** (fixed answer set) should be collected with the native **`AskQuestion`** tool (blocking checkbox/radio UI). See [ask-question-catalog.md](ask-question-catalog.md) for exact payloads.

**Attempt `AskQuestion` first** on every closed-choice moment — even if you are unsure it is listed. Do **not** pre-emptively use chat menus.

---

## Primary path: `AskQuestion`

Rules:

- Call the tool **before** writing the question in chat. The tool call *is* how you ask.
- **End your turn** after issuing `AskQuestion`. Wait for the UI answer.
- **Batch** related questions into one call when they belong together.
- Single-select → `allowMultiple: false` (or omit). Multi-select → `allowMultiple: true`.
- Keep option labels short.

### Exact tool invocation

Schema:

- `title` — optional string
- `questions` — array of `{ id, prompt, options: [{ id, label }], allowMultiple? }`

```xml
<function_calls>
<invoke name="AskQuestion">
<parameter name="title">Quarterly review setup</parameter>
<parameter name="questions">[ /* catalog §1 JSON */ ]</parameter>
</invoke>
</function_calls>
```

(Adapt serialization to your normal tool-call form; keep parameter names and shapes.)

If "Skip for now" is selected with other evidence sources, treat as **Skip only**.

Do **not** switch to Plan mode to “get” AskQuestion — Plan mode often forbids it and pushes prose questions.

---

## Fallback path: text menus (only after tool rejection)

Use this path **only when**:

1. You **emitted** an `AskQuestion` call, **and**
2. The platform returned an error that the tool does not exist / is not permitted (e.g. `Tool not found: AskQuestion`).

Do **not** fall back because you merely suspect the tool is missing.

### Mandatory warning (every fallback turn)

Before (or as the first lines of) any text menu, print this **verbatim block** (adapt the reason line only if the platform error text differs):

```markdown
> **⚠️ AskQuestion unavailable — text fallback**
>
> The interactive option picker (`AskQuestion`) is not available in this session
> (platform: tool not found / not permitted). Closed choices will use **typed
> replies** instead of the checkbox/radio UI.
>
> **Better UX:** re-run this review with a model/session that exposes `AskQuestion`
> (e.g. Claude Sonnet, Haiku, or GPT in Agent mode — Composer often lacks it).
>
> Continuing in text-fallback mode for this session.
```

Also log in the final report **Manager Confidence**:

- `Interaction: text fallback (AskQuestion unavailable)` plus the platform error summary.

Show the warning **once at the start of fallback** (setup), then a **one-line reminder** on later closed-choice turns:

```markdown
> *(Text fallback — AskQuestion unavailable; reply with option ids below.)*
```

### How to render text menus

Mirror the catalog: same `id`s, prompts, and options. Format:

```markdown
**{prompt}** `{id}` — reply with option id(s)
- `{option.id}` — {option.label}
- …
```

Rules:

- Single-select: ask for **one** option `id` (e.g. `scorecard`).
- Multi-select: ask for **one or more** ids, space-separated (e.g. `jira github`); if `skip` appears with others, treat as **skip only**.
- Batch the same questions that would have been one `AskQuestion` call into **one** assistant message.
- Accept ids, labels, or unambiguous abbreviations; reconcile before continuing.
- Stay consistent: once in text-fallback for the session, keep using it for later closed choices (do not keep re-calling `AskQuestion` every turn unless the manager switches model mid-session — then retry `AskQuestion` once).

### Still forbidden without the warning

Jumping straight to letter-menus **without** attempting `AskQuestion` and **without** the warning block is a skill failure.

---

## CLI-only emergency (optional third path)

`scripts/ask-select.sh` / `scripts/ask-multi.sh` (fzf) apply only if `AskQuestion` **errored** **and** the manager is in headless Cursor CLI with a real TTY. Prefer text fallback in the IDE when AskQuestion is missing. Never use fzf as the default.

---

## Freeform (not closed choice)

Employee name, level text, quarter/year, file path, pasted self-assessment/table, narrative evidence, and compact Y/P/N run-strings **after** batch-entry opt-in — these stay freeform chat.

---

## Progress header

```
Employee · Level · Period · Mode · Step X/… · [AskQuestion | text-fallback]
```
