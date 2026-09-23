---
name: wiki-dream-only
description: Run a dream pass and stop at the report — read across an LLM wiki's pages for connections no page states yet (bridges between subjects, open questions the vault can now answer, sources that independently agree, pages that should link and don't, patterns seen a third time) and write each as a cited, inference-marked proposal to outputs/dream-YYYY-MM-DD.md. Applies nothing and adds nothing from outside the vault; the report awaits review by wiki-dream-ingest. Built to run unattended as a scheduled task. Use when someone wants a dream pass written up for later, or to schedule dreaming — to schedule it, create a task whose prompt names this skill; setting up the schedule is not a pass. Use wiki-dream instead to dream and decide in one sitting, wiki-dream-ingest to work through a report already written, wiki-query to answer a specific question, wiki-gaps to find what to go and read, and wiki-lint to clean up or merge duplicates.
---

# Wiki Dream Only

REM sleep is when a brain consolidates what actually happened: it links the day's experiences to older memories and to each other. It does not invent new days. That is the whole discipline of this skill. **It connects what the vault already holds, and nothing else.** No web, no general knowledge, no fact that is not already on a page. Every connection it proposes has to be something a careful reader could see by putting two existing pages side by side.

Lint removes problems. Ingest adds sources. This adds *understanding* — and because understanding is a claim, everything it produces is inference, labelled as inference, cited to the pages it rests on, and filed only after a person approves it. **This skill writes the proposals and stops.** The report is the whole output; wiki-dream-ingest works through it with the person and applies what they approve, and wiki-dream runs the two in one sitting.

## How it sits with its neighbours

| | Looks at | Writes |
|---|---|---|
| wiki-query | the question the person asked | a note answering it |
| wiki-gaps | what the vault is missing — sources to go and find | nothing |
| wiki-lint | what is broken, duplicated or contradictory | repairs, on approval |
| **wiki-dream-only** | what the pages already add up to that no page says | a report, nothing else |
| wiki-dream-ingest | a dream report, with the person | the approved notes, links and citations |

If a connection can only be justified with knowledge from outside the vault, it is not a dream finding. It is a gap — hand it to wiki-gaps.

**One part only, and only where it is the only one.** Every finding a pass proposes has to be filable, with both halves linked in the same folder, and a connection whose halves sit in two parts cannot be. So a session that can reach two or more folders holding a `_meta/schema.md` runs no pass (`${CLAUDE_PLUGIN_ROOT}/skills/wiki-query/references/parts.md`, *A project that combines several wikis*): say in one line to run it from that part's own project, and write nothing — scheduled or not. Cross-part connections belong in an answer, which is wiki-query's job.

## Before you start

1. **Read `_meta/schema.md`, `index.md`, `overview.md`**, and `patterns.md` if the vault has one. If the schema's §9 does not list `dream`, or §11 has no Dream line, say so in the report — adding them is a schema change for the person, not for this pass.
2. **Read `_meta/log.md`** for four things:
   - the date of the last **dream pass** — the last `dream` entry with a `scope:` line. An entry that only reviews a report has no `scope:` line and does not count, so a review never hides the pages that changed before it.
   - every proposal any dream entry lists as `rejected:` — not re-proposed unless a new source has changed the case, and then say what changed.
   - a report still **awaiting review**: the latest `dream` entry that names the report carries an `unreviewed:` line — the pass that wrote it, or a review that left findings undecided. Don't re-propose its findings, undecided ones included: they come back when that report is worked through. With the person present, offer to work through it first with wiki-dream-ingest, unless that just happened, or wiki-dream already offered it, in this sitting.
   - **the register** — the hypotheses earlier passes left open, each with what would close it: a loop seen twice waiting for a third instance, a connection whose second half the vault didn't hold yet. It is this skill's memory, and checking it is the first thing the budget below pays for. It lives in the `watch:` and `near:` lines on earlier `dream` entries, minus any a later entry `closed:`. Each opens with its own short name in quotes and a `closed:` line repeats that name, so the live set is a grep rather than a judgement: `- watch: "retry-after handling" — …` is closed by `- closed: watch "retry-after handling" — …`. An unreviewed report holds back its *findings*, not its register: a `watch:` or `near:` line is live from the moment it is written, including the ones the last pass wrote alongside a report nobody has reviewed yet — that is the point of keeping it. Keep the live set at about a dozen: when it is longer, close the oldest, from already-reviewed reports first, one line each saying they didn't come back.
3. **Spend the budget, in this order.** Reading a page in full is the pass's only scarce resource: **at most ~25 wiki pages** (the frame pages, the schema and greps don't count), fewer on a small vault and no more on a large one — a big vault earns more passes, not longer ones. The shortlisting around them is cheap and unlimited: `index.md` one-liners and tags, the link graph resolved by name (`${CLAUDE_PLUGIN_ROOT}/skills/wiki-query/references/links.md`) at any folder depth, and shared vocabulary by grep. **Nothing here is about covering the vault evenly.** A vault does not owe its pages equal attention; the budget goes where there is a reason:

   1. **The register**, for at most a third of the budget. Test each live `watch:`/`near:` line against what has changed since the last pass: has the third instance arrived, has a source supplied the half that was missing? A line names its pages, so testing one costs the changed page plus one or two named ones, and its hit rate is the best here — an earlier pass already did the noticing. With more live entries than that third pays for, test the ones whose pages have changed and leave the rest untouched for next time. Fire it, leave it, or close it, and say which in the log.
   2. **Demand, for about a third — where the vault has already said an answer would matter.** `## Open questions` and `## Contradictions in play` in `overview.md`; the `- gap:` lines on `query` entries in the log since the last pass, which are questions the owner actually asked and the wiki could not answer; and a term the pages keep circling with no page of its own (lint check 4, from the newest lint report, if there is one). Read the pages these name.
   3. **What arrived.** Pages created or updated since the last dream pass, each paired **against the whole index**, not only against its neighbours: the pairs worth reading are close in vocabulary and far apart in the link graph — no link path between them, ideally a different subject. A bridge sits where two pages nearly touch and nothing connects them.
   4. **A silent reserve — two or three pages, taken even when the earlier steps could use them.** Pages with few or no inbound links — never a history companion, a page with `history-of:`, which is linked only from its own page by design — that no query, no open question and no recent source has touched, and that no `read:` line in the log shows a pass ever opened. This is not fairness. A silent cluster cannot produce a demand signal, so it is the only part of the vault whose potential is unmeasured; read one or two, and they either enter the register or are recorded as read and left alone for several passes.

   **The first pass on a vault is different:** no register, no `read:` lines, and every page silent, so parts 1 and 4 have nothing to do. Its scope is the whole vault rather than what changed, and the budget goes to part 2 and then to part 3, across the seams between subjects.

   **Write the register as you go.** A loop seen for the second time, a connection one quotable line short, a pair that nearly cleared the gate — each becomes a `watch:` or `near:` line naming what would close it (*Logging*, below). That is as much the pass's output as the report: it is what the next pass will not have to rediscover, and it is why a page is never "done" — it is revisited when a hypothesis or new material calls for it, never on a rota.

   Say what you did not cover, with the reason — in the report and in the log.

## What to look for

Six kinds of connection. `references/connection-types.md` has the detection recipe, the evidence required and the proposal format for each — read it before the pass.

1. **Bridge** — two pages whose lines, set side by side, yield a consequence neither states: the same mechanism described twice, the same term in different senses, or one page's open question answered by the other. Usually across subjects; inside one subject only when neither page already draws the consequence.
2. **Answerable question** — an open question in `overview.md` or on a page that combining existing pages now answers.
3. **Convergence** — two sources that state the same claim independently, while the page holding it cites only one.
4. **Missing link** — a page that discusses another page's subject by name, without linking it. Two pages that *are* one subject under two names are duplicates — lint check 3, not a link.
5. **Pattern** — a loop that now shows up in a third source, which is the bar `patterns.md` sets for a place on the page. Includes **drift**: a claim that has moved twice or more across a source's `## Version history` lines and the `## History` of the pages carrying it, history companions included. Skip when the vault has no `patterns.md`.
6. **Productive tension** — two positions that can both be true and still cannot both be followed. A **contradiction** is different: two claims about the same fact that cannot both be true. Contradictions belong to lint check 5; hand them there.

## The gate every finding must pass

Before anything is proposed, check all five. A finding that fails one is dropped, not softened.

- **Both halves are source-backed.** Each half is a line you can quote from a source page, or from another page where it carries a link to a source page — inline, or in a block-level attribution that plainly covers it ("All rows — [[source]]"). Frontmatter `sources:` alone does not back a line. Not a half: a line marked *(inference)*, anything under an `## Interpretation` heading, anything in the overview's "What we know so far", anything on a note (any page of type note, wherever it sits) — a filed answer as much as a `synthesis` note — and an uncited line that generalises across sources, which is synthesis even unmarked. Building on earlier synthesis compounds it into something that reads as established.
- **The step is written out.** State it as *A (quoted, cited) + B (quoted, cited) ⟹ C*, then list under `Unstated premises:` anything else the step relies on. A premise that is a fact about the world rather than a step of reasoning fails the finding — that fact is what the vault is missing, so it goes to wiki-gaps. A fact the schema states about the vault itself counts as held; anything else, state the conclusion conditionally ("for a vault in a local folder…") rather than assume it. "None" is the answer you want.
- **It is not already written.** Neither page states the connection, no note does, and no line in `overview.md` does, inference lines included. A more general version elsewhere does not disqualify it — name that version under *Weakest point*.
- **It would survive the person reading both pages side by side.** If they would say "that's a stretch", it is.
- **It changes something.** A connection that alters what the vault can answer, or what the overview should say, beats one that is merely true.

For a **missing link** the gate is shorter: the passage is not an inference or interpretation line; it uses the term in the target page's sense; and for a hub page — the owner, the main subject — the passage is about what that entity did or said, not a passing mention.

Three real connections beat seven plausible ones. **Zero is a valid result**, and on a young vault the honest one — say so rather than filling the report.

## The report

Nothing is written to `wiki/` — not now, not later by this skill.

1. Write the report to `outputs/dream-YYYY-MM-DD.md` — said as it lands, `+ outputs/dream-YYYY-MM-DD.md` (`${CLAUDE_PLUGIN_ROOT}/skills/wiki-ingest-pending/references/batch-ingest.md`, *Showing progress*) — from `assets/report-template.md`, created no-clobber — if the name is taken, add `-2` (`${CLAUDE_PLUGIN_ROOT}/skills/wiki-setup/references/locking.md`, *New files*): at most seven findings, ranked by how much each changes what the vault can say. The missing links of a pass are one finding, however many links it holds. For each: the kind, both halves quoted with their pages, the *A + B ⟹ C* step and its unstated premises, what it would change, the proposed action, and the exact line `overview.md` would gain, if any. List what you hand to lint — each item with its check number — and to wiki-gaps separately.
2. Give the summary in chat: the findings, one line each, by number, and that the report awaits review — wiki-dream-ingest works through it with the person. Run by wiki-dream, hand over the report instead; the review follows at once.

## Running unattended

A pass is unattended when a scheduled task started it or its prompt says so. Find the vault as wiki-maintain's step 0 does — by the `_meta/schema.md` in a connected folder, the name in the prompt being only a hint — and with no connected folder, or two or more holding a schema — whatever the prompt names — write nothing and say so. It runs exactly as it does with the person present, because it never applies anything anyway: everything it could write into `wiki/` is a new claim, which only a person can approve. Its findings reach the person through the scheduled task's notification, wiki-maintain's digest and wiki-status, all of which say a report is awaiting review.

**Cadence:** the Dream line in §11 of the schema. Where the schema sets none, a pass is due once ten or more sources have been ingested since the last dream pass. Connections need material to build up between passes; run it too often and it produces noise. `wiki-maintain` says in its digest when a pass is due.

## Logging

The report is a new file, so the pass needs no vault lock; append the entry in one write, as `${CLAUDE_PLUGIN_ROOT}/skills/wiki-setup/references/locking.md` (*The log*) says:

```markdown
## [2026-09-21] dream | 18 pages read, 4 proposed
- scope: register 5 checked, 1 fired · demand 3 (2 open questions, 1 query gap) · 9 changed since [2026-08-20] · 2 silent
- read: [[queue-design]], [[rate-limits]], [[retry-policy]], … (every page opened in full)
- not covered: wiki/entities/ beyond the shortlist
- proposed: 1 bridge [[a]]↔[[b]]; 2 answered "open question X"; 3 missing links ×3; 4 tension [[c]]↔[[d]]
- watch: "retry-after handling" — [[queue-design]], [[rate-limits]]; a third instance makes it a pattern
- near: "job cadence" — [[a]] ↔ [[g]]; needs a source stating how often the job runs
- closed: watch "naming drift" — no third instance in 4 passes; not a pattern
- for lint: 5 | [[e]]↔[[f]] | founding year 2019 vs 2021
- unreviewed: outputs/dream-2026-09-21.md
```

The proposed count counts findings as the report does — the batch of missing links is one; the `proposed:` line gives them by number. The `scope:` line is what marks this as a dream pass: the next one is measured from it. `read:` is page names only, and it is what step 3's silent reserve reads to tell an unopened page from a well-worked one. `watch:`, `near:` and `closed:` are the register — kept in the log because it is append-only and needs no lock, and because a hypothesis about the vault is not a fact and must never be written into `wiki/`. Each `watch:` and `near:` opens with its own short name in quotes, and a `closed:` line repeats that name exactly, so the live set is what a grep of the two minus the third leaves. (`retired:` is a different line, belonging to lint: a retired source page.)

**A pass that proposes nothing is a result, not a failure.** It logs `0 proposed` and `- report:` in place of `unreviewed:` — there is nothing to review — and says why in one line: nothing arrived on the seams, the register didn't fire, the open questions are unchanged. On a settled vault one or two findings is the ordinary shape of a pass. Six findings from a vault that took in nothing new is a symptom: the gate slipped. wiki-dream-ingest writes the decisions — `accepted:`, `rejected:`, `dropped:`, `undecided:` — on its own entry.

## Reference files

- `references/connection-types.md` — the six kinds, with detection recipes, required evidence, and the proposal for each. Read before the pass.
- `assets/report-template.md` — the report structure. Copy and fill.
- `${CLAUDE_PLUGIN_ROOT}/skills/wiki-dream-ingest/SKILL.md` — how the report is worked through and applied; the proposed actions must be ones it can apply.

## Debug mode

When schema §11's `Debug:` line says `on`, or the person asks for this run to be in debug mode, also record what these instructions made you guess — `${CLAUDE_PLUGIN_ROOT}/skills/wiki-setup/references/debug-mode.md`. It changes nothing about how this skill runs.
