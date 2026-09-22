---
name: wiki-lint
description: Health-check and repair an LLM wiki — find contradictions between pages, stale claims newer sources have superseded, orphan pages nothing links to, concepts mentioned everywhere but lacking a page, duplicate pages to merge, broken links, index drift, thin stubs, and knowledge gaps worth researching — then propose fixes, apply the approved ones, and suggest the next questions and sources. Use whenever someone asks to clean up, audit, review, tidy or health-check their wiki, vault, second brain or knowledge base, when wiki-maintain runs it, after a big batch ingest, or when the wiki "feels messy" or they can't find things anymore. Use wiki-maintain instead for the whole routine (ingest what is pending, lint, digest), wiki-dream for new connections and insights rather than repairs, and wiki-gaps when they only want to know what to read next, without a clean-up.
---

# Wiki Lint

Wikis rot in predictable ways: duplicate concepts under different names, claims quietly superseded by later sources, pages nobody links to, an index that stopped matching reality. All of it is findable, and fixing it is cheap for an agent and unbearable for a human — which is the entire reason this pattern works.

## Run order

1. **Read `_meta/schema.md`.** The wiki is linted against its own conventions, not generic ones. Note anything the schema mandates that pages might have drifted from.
2. **Take inventory.** Count pages by type, list every filename at any depth — pages may sit in subfolders of their type folder, or wherever the owner put them — read `index.md` and the recent entries in `_meta/log.md`. Note the last lint date; lint the delta if it was recent, everything if it's the first pass. Either way, also check every page named on a `for lint:` line in `dream` entries since the last lint — a dream pass hands those over instead of fixing them.
3. **Run the checks** in `references/checks.md` — thirteen of them, each with a detection recipe and a fix pattern. Collect findings; don't fix as you go. On a large vault, parallelise with the read-only `wiki-auditor` sub-agent, one slice each (a folder, or one check across everything), then merge what comes back — under a lock an unattended wiki-maintain run holds, renew it first for as long as the auditors will take, since they can't renew it — regrouping and re-ranking anything a check reports by page, such as check 6's propagation gaps, since each slice sees only part of a page's list. Where the auditors' file tools can't reach the vault — Cowork with the vault on the person's computer — copy each slice into the session's workspace first — with the schema, the log, a list of every page name, the links into the slice's pages where its checks need them, and a listing of `raw/` for checks 7 and 11 — and tell the auditor which vault path each copy stands for (`${CLAUDE_PLUGIN_ROOT}/agents/wiki-auditor.md` says what it needs). For link and structure checks on a large vault, the recipes in `references/checks.md` run faster in the main session, with the shell where the vault is. **Hand each one five things:** the vault's `_meta/schema.md`, the path `${CLAUDE_PLUGIN_ROOT}/skills/wiki-lint/references/checks.md`, today's date, its slice — a folder, a list of pages, or the check numbers it owns, by their numbers in that file — and `_meta/log.md`, whose `retired:`, `kept:`, `declined:`, `outside:`, `gap:` and `support-checked:` lines checks 1, 6, 7 and 9–12 read. Check 7's support sample picks its pages across the whole vault, so the main session chooses them and hands them out; it writes the `support-checked:` line itself. Without the schema, the check list or a slice it stops and says so; without the date it reports the date-dependent checks (6, 10, 11, 13) as unverified rather than guessing. On a large vault, tell the person how the pass is split and report as each slice comes back (`${CLAUDE_PLUGIN_ROOT}/skills/wiki-ingest-pending/references/batch-ingest.md`, *Showing progress*).
4. **Write the report** to `outputs/lint-YYYY-MM-DD.md`, said as it lands (`+ outputs/lint-YYYY-MM-DD.md`), using `assets/report-template.md`, created no-clobber (`${CLAUDE_PLUGIN_ROOT}/skills/wiki-setup/references/locking.md`, *New files*), and give the person the summary in chat.
5. **Propose fixes in batches**, grouped by kind and by risk. Mechanical fixes — the parts of checks 1, 8 and 9 that `references/checks.md` marks mechanical: typo, rename and alias repoints of links, index rows, check 9's mechanical fields — can be applied on a single yes. Judgement calls (merging pages, retiring claims, deleting anything, a duplicate name, a placement, subject or grouping proposal, a support-sample finding) get approved individually. Moving files happens only with the person present, by `${CLAUDE_PLUGIN_ROOT}/skills/wiki-setup/references/grouping.md`.
6. **Apply, verify, log.** Say each file created or moved as it happens (`${CLAUDE_PLUGIN_ROOT}/skills/wiki-ingest-pending/references/batch-ingest.md`, *Showing progress*). Collect the approvals first. Then take the vault lock (`${CLAUDE_PLUGIN_ROOT}/skills/wiki-setup/references/locking.md`), apply, re-verify and release it — unless an unattended wiki-maintain run holds it. An approved move runs afterwards, by grouping.md, which asks its own pre-flight and takes the lock itself. Writing the report needs no lock.

## The checks, in brief

Details and detection recipes in `references/checks.md`. Order matters — later checks depend on earlier fixes.

| # | Check | Why it matters |
|---|---|---|
| 1 | Broken links and duplicate names | a link pointing nowhere, or at a name two files share |
| 2 | Orphan pages | nothing links in; invisible except through the index |
| 3 | Duplicate pages | same thing under two names, or a sync conflict copy; the fastest way a wiki rots |
| 4 | Missing pages | a concept referenced across many pages with no page of its own |
| 5 | Contradictions | conflicting claims, flagged or unflagged, across pages |
| 6 | Stale claims | superseded by a newer source, or old on a fast-moving topic; pages a source names that don't cite it, and the reverse |
| 7 | Uncited and unsupported claims | facts with no source link — rumours with good posture — and a sample of cited claims tested against their sources |
| 8 | Index drift | rows missing, summaries wrong, counts stale, groups out of line |
| 9 | Frontmatter hygiene and placement | missing `updated:`, `sources:`, `status:`; schema violations; a page's folder and frontmatter disagree; a subject the vote clearly contradicts |
| 10 | Thin and bloated pages and folders | perpetual stubs; pages past ~1,200 words that should split; a type folder big enough to group, a new subject or a split |
| 11 | Unprocessed and orphaned sources | files in `raw/` that no source page covers — usually clips nobody ingested |
| 12 | Gaps and next questions | what the wiki should know and doesn't |
| 13 | Out-of-scope and expired sources | material the capture gate should have stopped, or that has passed its date |

## Fixing well

- **Report before repair.** The person should see the shape of the problem before pages start moving. An unattended lint that rewrites thirty pages is how people lose trust in the vault — and an unattended lint never moves a file at all.
- **The owner's folders win.** A page the person moved stays where they put it; the proposal is to change the frontmatter to match, not to move the page back — except a page in another year's folder, where the date is never edited and moving it back is proposed, with the person present (check 9).
- **Never delete without explicit approval on that specific page.** Merging, superseding and archiving are almost always the right move instead.
- **Preserve history.** Superseded claims move to a `## History` section with a date and reason, not into the void.
- **Fix the cause, not the symptom.** A broken link usually means a page got renamed — fix every inbound link, and add the old name to the survivor's `aliases:`. Recurring frontmatter violations usually mean the schema is wrong or unclear; propose a schema change instead of patching page after page.
- **Batch edits per page.** Read once, apply everything that changes for that page, write once.
- **Re-verify after applying.** Re-run checks 1, 2 and 8 — fixes create new broken links, orphans and index drift surprisingly often.

## Gaps and next moves — the part people actually want

The audit is hygiene; this section is why they'll run it again. Finish every lint with:

- **Questions the wiki is now close to answering** but hasn't — where two pages nearly meet. Name them; wiki-dream is the skill that writes the connecting analysis, with approval.
- **Sources worth finding**, named specifically: the paper everything cites but nothing here holds; the competitor with no Q3 numbers; the counter-argument the vault has never heard. Offer to fetch and ingest one now.
- **Contradictions worth resolving**, with what would settle each.
- **The shape of the wiki**: which topics are dense, which are one page deep, and whether that matches what they said the wiki is for.

## Scheduling it

Lint runs as part of **wiki-maintain**, which is the routine to schedule — it ingests everything pending, lints, and writes a digest in one pass. Suggest scheduling that on the project: weekly suits an active vault, monthly a slow one. A standalone scheduled lint is still fine when there is nothing to ingest:

> *"Run a lint pass on the wiki, write the report to outputs/, and message me the three things most worth my attention."*

Scheduled runs should report and propose, not silently rewrite. Keep the repair step human-approved unless the person has explicitly asked for autonomous cleanup, in which case restrict it to mechanical fixes (the mechanical parts of checks 1, 8 and 9 — never a move).

## Logging

```markdown
## [2026-09-20] lint | full pass, 84 pages
- fixed: 12 broken links, 6 index rows, 9 frontmatter fields
- merged: [[llm-wiki]] ← [[llm-knowledge-base]]
- flagged: 3 contradictions, 5 stale claims (unresolved, see report)
- report: outputs/lint-2026-09-20.md
- suggested: 4 sources to find, 3 questions to answer
- kept: wiki/concepts/pricing/churn-drivers.md (placement: stays in pricing/, subject not changed)
- kept: wiki/sources/field-trip-notes.md (subject)
- declined: grouping of wiki/sources/
- declined: subject regional-offices
- support-checked: [[pricing-pressure]] (3), [[channel-strategy]] (3), [[acme]] (2)
```

`kept:` and `declined:` record proposals the person turned down — a `kept:` line names in brackets which finding it silences, and silences only that one — and `outside:` a page the owner moved out of `wiki/`, so the next pass doesn't raise them again (checks 1, 9 and 10). `support-checked:` records which pages check 7 sampled and how many claims on each, so the next pass samples others first.

## Reference files

- `references/checks.md` — the thirteen checks with detection recipes, severity and fix patterns. Read this before running the pass.
- `assets/report-template.md` — the report structure. Copy and fill.
