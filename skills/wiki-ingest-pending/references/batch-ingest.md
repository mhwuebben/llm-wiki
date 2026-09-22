# Batch ingest

Ingesting many sources at once is where these wikis usually get ruined: pages get written in parallel by agents that can't see each other's edits, the overview gets clobbered, duplicates appear under synonyms, and nobody trusts the result.

## The rule

**Reading and source-page drafting can be parallel. Propagation must be serial.**

Everything in `wiki/sources/` is independent — one file per source, no shared state. Everything else (`entities/`, `concepts/`, `overview.md`, `index.md`, `_meta/log.md`) is shared state, and concurrent writers will overwrite each other.

## Recommended flow

1. **Inventory.** List the sources, in the order you'll take them: oldest publication date first (wiki-ingest-pending, *Before you start*, step 3), unless the person asks for most-important-first. Give each source a unique slug now — two sources with the same title (an annual report, 2024 and 2025) need distinct names before any reader runs — and check that no file anywhere in the vault already has it. Check each against the existing source pages for duplicates and against the schema's out-of-scope list (wiki-ingest-pending, *Before you start*, steps 4 and 5) before any reader is dispatched — a reader writes a source page, and an out-of-scope file must not get one unless the person has overridden the rule (wiki-ingest-pending, *Before you start*, step 5). A re-capture of a source that already has a page gets no reader either: the main session updates that page itself (wiki-ingest-pending, *Before you start*, step 4). Then show the list and, for more than three sources, get a yes.
2. **Read and draft in parallel.** Before dispatching, extend the vault lock's lease to cover the wait (`${CLAUDE_PLUGIN_ROOT}/skills/wiki-setup/references/locking.md`, *Holding it*): the readers can't renew it. Where sub-agents are available, one source each: read the source, draft its source page under the slug you assigned — in the folder schema §3 assigns, which the reader works out after reading, since only then are `published:` and the subject known — and return the path it wrote and a structured touch list (entities, concepts, claims, contradictions, open questions). The `wiki-reader` agent is built for this and already has the write limits baked in; without it, give each sub-agent the schema and the source-page template and tell it explicitly not to touch any other file. When the cap below may cut the batch short — an unattended run, or more items than it is likely to allow — dispatch readers in waves of about five, in order, and stop once the merged touch lists reach the cap: an item held back must never be left with a drafted source page, which would read as an interrupted ingest.
3. **Merge the touch lists yourself.** Deduplicate across sources — the same concept will arrive under three names. Decide the canonical name once, here, before any page gets created, and rewrite each drafted source page's `## Entities and concepts` to the canonical names — otherwise the closing step later skips a synonym as a forward link.
4. **Propagate serially**, source by source, oldest first, following `propagation.md` — and close each source's list (*Close the list*) before starting the next. Later sources then correctly show up as updating or contradicting earlier ones, which is the behaviour you want. In a vault with subjects, re-run *Assigning a subject* (`${CLAUDE_PLUGIN_ROOT}/skills/wiki-setup/references/grouping.md`) at each source's turn: the reader decided before the earlier sources' pages existed. Report a different answer; don't move the file — lint proposes it (check 9).
5. **One index rebuild and one log entry per batch**, not per source — but the log entry names every source and the page counts:

```markdown
## [2026-09-20] ingest | batch of 7 (Q3 competitor filings)
- sources: [[acme-q3]], [[globex-q3]], ... (7 pages in wiki/sources/)
- new: [[pricing-pressure]], [[channel-strategy]] (+3 entities)
- updated: 14 pages, [[overview]], [[index]]
- flagged: 2 contradictions — see [[pricing-pressure]]
```

6. **Report, then offer a lint.** After a batch of more than about five sources, a lint pass almost always finds duplicate concepts and thin pages worth merging.

## Without sub-agents

Do it serially, and keep it short. One run takes about eight items at most, however many were approved — past that, quality slides as context fills. Offer to split the rest across sessions rather than degrading quietly; unattended, leave them pending and say so.

## Quality guards for every batch

- **Same-name check** before every page creation, including aliases and near-synonyms.
- **No new pages below the promotion bar.** Batches inflate page counts fast; hold the line.
- **Cap it.** A batch that would create more than ~20 new pages — entity, concept and other named pages; source pages don't count — stops there: ingest the items that fit, oldest first, and leave the rest pending. With the person present, offer the rest after the report, as a new pass — not as a question in the middle of one, while the lock is held.
- **Keep the person's review loop alive.** Even in batch mode, report a changelog they can scan in thirty seconds, and name the two or three most interesting things the batch turned up. A batch ingest that produces no surprises usually means nothing was read carefully.
