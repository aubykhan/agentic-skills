# Default competency rubric (fallback)

This is the **fallback** rubric used only when the manager provides **no external competency sheet** and wants to move fast. Prefer an org sheet or pasted table (see [competency-sheet-spec.md](competency-sheet-spec.md)); this file exists so a review is never blocked on a file.

- Scope: **competency content only**. Potential questions live in `SKILL.md` (single source).
- Structure: flat list keyed by `Level` → `CompetencyArea` → `QuestionText`. Twenty items per level, five per area, four areas.
- Areas (fixed order): **Technical Skills**, **Delivery**, **Feedback, Communication & Collaboration**, **Leadership & Strategic Impact**.
- Levels: **SWE** (L3), **SWE2** (L4), **SSE** (L5), **SSE2** (L6), **PSE** (L6-IC).

**Usage**
- **Scorecard:** each `QuestionText` is one **Y / P / N** line under its `CompetencyArea` (Phase A / current bar). This default has no `next_level_bar` rows, so Phase B is narrative-only unless the manager supplies next-level expectations.
- **Conversation:** open per `CompetencyArea` with a paraphrase; draw at most **2** probes per area from the items below to fill gaps in the manager's story.
- Follow the **no question IDs in written output** rule — refer to competency areas and item substance in plain language, never `Q3` / `item 5`.

---

## SWE (L3)

**Technical Skills**
1. Wrote clean, testable code with appropriate error handling
2. Added unit or integration tests for their work
3. Used monitoring or logging tools to debug issues
4. Participated in code reviews (giving and receiving feedback)
5. Showed awareness of security principles or full-stack concepts

**Delivery**
6. Broke work into manageable tasks and tracked progress
7. Delivered on time, or communicated blockers early
8. Owned a feature end-to-end (plan → develop → test → deploy → monitor)
9. Balanced urgency with quality
10. Understood dependencies and incremental delivery

**Feedback, Communication & Collaboration**
11. Sought and applied feedback from code reviews
12. Gave constructive, focused feedback on others' code
13. Communicated clearly in writing and speech
14. Handled disagreements respectfully and built positive relationships
15. Shared knowledge or helped unblock teammates

**Leadership & Strategic Impact**
16. Understood how their work aligned with team/org objectives
17. Followed team processes (agile, code review, deployment)
18. Was reliable and consistent in execution
19. Showed initiative beyond assigned tasks
20. Demonstrated growing product/business awareness

---

## SWE2 (L4)

**Technical Skills**
1. Designed modular components or abstractions reused by others
2. Debugged and resolved cross-system or complex production issues
3. Wrote technical design proposals reviewed by peers
4. Led code reviews that prevented bugs or drove improvements
5. Demonstrated solid understanding of the team's domain

**Delivery**
6. Led delivery of multi-ticket features or small projects
7. Navigated scope changes or requirement shifts successfully
8. Collaborated across functions (product, QA, infra)
9. Applied cost-value thinking in technical decisions
10. Owned outcomes, not just tasks

**Feedback, Communication & Collaboration**
11. PR feedback led to measurable improvements in others' work
12. Led or facilitated design reviews, retros, or knowledge-sharing sessions
13. Mentored or unblocked 2+ teammates
14. Created or updated documentation used by the team
15. Communicated clearly across different audiences

**Leadership & Strategic Impact**
16. Translated vague requirements into clear engineering tasks
17. Proposed UX or scope improvements that were accepted
18. Flagged low-value or misaligned work
19. Led or co-led process or tooling improvements
20. Demonstrated understanding of business impact and customer context

---

## SSE (L5)

**Technical Skills**
1. Designed systems or components used across multiple domains
2. Led or significantly contributed to technical design reviews
3. Drove adoption of technical standards (testing, CI, observability)
4. Owned a focused area of the tech stack deeply
5. Mentored SWE2s in adopting best practices

**Delivery**
6. Led planning and execution of large-scale or multi-epic projects
7. Navigated high-ambiguity situations and drove clarity
8. Reduced delivery risk or inefficiencies measurably
9. Improved operational processes (on-call, releases, incidents)
10. Balanced urgency with team sustainability

**Feedback, Communication & Collaboration**
11. Mentored multiple engineers with visible impact on their growth
12. Drove cross-functional alignment on technical decisions
13. Facilitated difficult discussions or retrospectives
14. Feedback resulted in measurable teammate improvement
15. Built trust with non-engineering stakeholders

**Leadership & Strategic Impact**
16. Aligned projects with team/org-level objectives
17. Designed or implemented process improvements adopted by the team
18. Contributed to hiring (interviews, calibration, bar-setting)
19. Addressed team capability or knowledge gaps
20. Operated beyond their current scope consistently

---

## SSE2 (L6)

**Technical Skills**
1. Designed scalable, maintainable systems anticipating future use cases
2. Owned team-level architecture and technical direction
3. Drove testability, monitoring, and security-first practices
4. Led incident response or root cause analysis
5. Went deep in a focused area of the tech stack

**Delivery**
6. Owned breakdown and delivery of epics and projects end-to-end
7. Applied cost-value thinking across the team
8. Maintained delivery throughput while investing in operations
9. Proactively managed dependencies, blockers, and risks
10. Acted with urgency while ensuring team sustainability

**Feedback, Communication & Collaboration**
11. Mentored teammates to build redundancy and autonomy
12. Translated technical details into business language for stakeholders
13. Built a culture of constructive feedback and psychological safety
14. Encouraged open discourse and integrated dissenting views
15. Unblocked others and promoted shared ownership

**Leadership & Strategic Impact**
16. Improved team processes using metrics (velocity, efficiency)
17. Played an active role in hiring and onboarding
18. Identified team growth areas and addressed bottlenecks
19. Helped team align decisions with org-level strategy
20. Drove experimentation and continuous improvement

---

## PSE (L6-IC)

**Technical Skills**
1. Defined or evolved org-wide standards across stacks
2. Led architectural design for large-scale changes
3. Created POCs to validate technical direction or 10x readiness
4. Led incident response across the org
5. Applied systematic debugging across multiple domains

**Delivery**
6. Managed delivery of multi-team, multi-quarter initiatives
7. Used metrics to close delivery, test, or process gaps org-wide
8. Drove technical tradeoffs optimizing for long-term value
9. Coordinated priorities and timelines across groups
10. Influenced broader testing and release strategies

**Feedback, Communication & Collaboration**
11. Mentored engineers across multiple teams
12. Ran training programs or fostered org-wide learning culture
13. Led high-stakes design reviews and cross-team alignment calls
14. Ensured cross-team communication was audience-appropriate
15. Built strong relationships across teams and functions

**Leadership & Strategic Impact**
16. Defined long-term system vision across domains
17. Aligned technical evolution with product/business goals
18. Shaped org-wide engineering culture
19. Drove alignment and resolved blocks across teams
20. Led strategic initiatives that improved the engineering org
