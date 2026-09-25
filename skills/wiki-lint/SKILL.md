---
name: wiki-lint
description: Health-check and repair an LLM wiki — find contradictions between pages, stale claims newer sources have superseded, orphan pages nothing links to, concepts mentioned everywhere but lacking a page, duplicate pages to merge, broken links, index drift, thin stubs, and knowledge gaps worth researching — then propose fixes, apply the approved ones, and suggest the next questions and sources. Use whenever someone asks to clean up, audit, review, tidy or health-check their wiki, vault, second brain or knowledge base, when wiki-maintain runs it, after a big batch ingest, or when the wiki "feels messy" or they can't find things anymore. Use wiki-maintain instead for the whole routine (ingest what is pending, lint, digest), wiki-dream for new connections and insights rather than repairs, wiki-gaps when they only want to know what to read next, without a clean-up, and wiki-help for why the vault or its graph looks the way it does.
---

# Wiki Lint

Wikis rot in predictable ways: duplicate concepts under different names, claims quietly superseded by later sources, pages nobody links to, an index that stopped matching reality. All of it is findable, and fixing it is cheap for an agent and unbearable for a human — which is the entire reason this pattern works.

**One vault, and only where it is the only one.** When this session can reach two or more folders holding a `_meta/schema.md`, it is a combined session and lint does not run (`${CLAUDE_PLUGIN_ROOT}/skills/wiki-query/references/parts.md`, *A project that combines several wikis*): say in one line to run it from that part's own project, naming the part, and write nothing — no report, no fix. A foreign citation — quoted text naming another part and its vault id — is deliberate, not a broken link: checks 1, 4, 5 and 7 leave it alone.

## Run order

1. **Read `_meta/schema.md`.** The wiki is linted against its own conventions, not generic ones. Note anything the schema mandates that pages might have drifted from.
2. **Take inventory.** Count pages by type, list every filename at any depth — pages may sit in subfolders of their type folder, or wherever the owner put them — read `index.md` and the recent entries in `_meta/log.md`. Note the last lint date; lint the delta if it was recent, everything if it's the first pass. Either way, also check every page named on a `for lint:` line in `dream` entries since the last lint — a dream pass hands those over instead of fixing them. A full pass covers everything, whatever a recent ingest verified: ingest's Step 5b is a three-check delta over the pages it just wrote, and it is not a substitute for this pass — it just means those checks usually find nothing on the newest pages.
3. **Run the checks** in `references/checks.md` — fourteen of them, each with a detection recipe and a fix pattern. Collect findings; don't fix as you go. On a large vault, parallelise with the read-only `wiki-auditor` sub-agent, one slice each (a folder, or one check across everything), then merge what comes back — under a lock an unattended wiki-maintain run holds, renew it first for as long as the auditors will take, since they can't renew it — regrouping and re-ranking anything a check reports by page, such as check 6's propagation gaps, since each slice sees only part of a page's list. Where the auditors' file tools can't reach the vault — Cowork with the vault on the person's computer — copy each slice into the session's workspace first — with the schema, the log, a list of every page name, the links into the slice's pages where its checks need them, a listing of `raw/` for checks 7 and 11, and the import records in `_meta/imports/` where the vault has any — and tell the auditor which vault path each copy stands for (`${CLAUDE_PLUGIN_ROOT}/agents/wiki-auditor.md` says what it needs). For link and structure checks on a large vault, the recipes in `references/checks.md` run faster in the main session, with the shell where the vault is. **Hand each one five things** — six where the vault has imported folders: the vault's `_meta/schema.md`, the path `${CLAUDE_PLUGIN_ROOT}/skills/wiki-lint/references/checks.md`, today's date, its slice — a folder, a list of pages, or the check numbers it owns, by their numbers in that file — and `_meta/log.md`, whose `retired:`, `kept:`, `declined:`, `outside:`, `gap:` and `support-checked:` lines checks 1, 6, 7 and 9–12 read; and the import records in `_meta/imports/`, which checks 3, 6, 9 and 11 read to tell a moved or withdrawn file from a new one. Check 14 compares the whole log with page frontmatter, so it stays in the main session rather than going to an auditor, which sees only a slice — and it needs a shell for the inbox part. Check 7's support sample picks its pages across the whole vault, so the main session chooses them and hands them out; it writes the `support-checked:` line itself. Without the schema, the check list or a slice it stops and says so; without the date it reports the date-dependent checks (6, 10, 11, 13, 14) as unverified rather than guessing. On a large vault, tell the person how the pass is split and report as each slice comes back (`${CLAUDE_PLUGIN_ROOT}/skills/wiki-ingest-pending/references/batch-ingest.md`, *Showing progress*).
4. **Write the report** to `outputs/lint-YYYY-MM-DD.md`, said as it lands (`+ outputs/lint-YYYY-MM-DD.md`), using `assets/report-template.md`, created no-clobber (`${CLAUDE_PLUGIN_ROOT}/skills/wiki-setup/references/locking.md`, *New files*), and give the person the summary in chat.
5. **Apply the mechanical fixes, then propose the rest — with a recommendation.** The mechanical parts of checks 1, 8 and 9 (typo, rename and alias repoints of links, index rows, check 9's mechanical fields) have one right answer each: take the vault lock, apply them, release it, and report what was applied — as an unattended run does. The lock is taken for that write alone and released before anything is put to the person, since it is never held across a question (`${CLAUDE_PLUGIN_ROOT}/skills/wiki-setup/references/locking.md`); step 6 takes it again for whatever they then approve. Asking permission for twenty-eight index counts that are simply wrong spends the person's attention on the one part of the pass with nothing to decide, and the log entry is the record if they want one reversed. The exception stays: a mechanical fix that would rewrite the text of many pages waits for a yes.

   **Judgement calls come with a recommendation and an order, never as a menu.** For each: what you would do, why, roughly what it costs, and what it clears — *"I'd do 1 now: ten minutes, and it also clears most of the reverse-citation finding. 2 I'd leave this pass. The split is yours to call — here is the seam."* The person's answer is then a yes or a "not that one", which is a smaller thing to ask of them than choosing between four options with no stated preference. Ending a report with "which do you want?" and no recommendation is the failure this rule exists to stop. Judgement calls (merging pages, retiring claims, deleting anything, a duplicate name, a placement, subject or grouping proposal, a support-sample finding) get approved individually. Moving files happens only with the person present, by `${CLAUDE_PLUGIN_ROOT}/skills/wiki-setup/references/grouping.md`.
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
| 10 | Thin and bloated pages and folders | perpetual stubs; pages past schema §10's Split past (~1,200 words if it has none, `## History` not counted) that should split; a type folder big enough to group, a new subject or a split |
| 11 | Unprocessed and orphaned sources | files in `raw/` that no source page covers — usually clips nobody ingested |
| 12 | Gaps and next questions | what the wiki should know and doesn't |
| 13 | Out-of-scope and expired sources | material the capture gate should have stopped, or that has passed its date |
| 14 | Work that left no trace | pages changed with nothing in the log, a gap named while the answer waits in the inbox, a source page that propagated nothing |

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

Scheduled runs apply the mechanical fixes — the mechanical parts of checks 1, 8 and 9, never a move — and report every judgement call rather than acting on it. That is the same line an attended run draws (step 5); the difference between the two is who is there to answer, not what gets applied without asking.

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

`kept:` and `declined:` record proposals the person turned down — a `kept:` line names in brackets which finding it silences, and silences only that one — and `outside:` a page the owner moved out of `wiki/`, so the next pass doesn't raise them again (checks 1, 6, 9, 10 and 14). `support-checked:` records which pages check 7 sampled and how many claims on each, so the next pass samples others first.

## Reference files

- `references/checks.md` — the fourteen checks with detection recipes, severity and fix patterns. Read this before running the pass.
- `assets/report-template.md` — the report structure. Copy and fill.

## Debug mode

When schema §11's `Debug:` line says `on`, or the person asks for this run to be in debug mode, also record what these instructions made you guess — `${CLAUDE_PLUGIN_ROOT}/skills/wiki-setup/references/debug-mode.md`. It changes nothing about how this skill runs.
