# Batch ingest

Ingesting many sources at once is where these wikis usually get ruined: pages get written in parallel by agents that can't see each other's edits, the overview gets clobbered, duplicates appear under synonyms, and nobody trusts the result.

## The rule

**Reading and source-page drafting can be parallel. Propagation must be serial.**

Everything in `wiki/sources/` is independent — one file per source, no shared state. Everything else (`entities/`, `concepts/`, `overview.md`, `index.md`, `_meta/log.md`) is shared state, and concurrent writers will overwrite each other.

## Recommended flow

1. **Inventory.** List the sources, in the order you'll take them: oldest publication date first (wiki-ingest-pending, *Before you start*, step 3), unless the person asks for most-important-first. Give each source a unique slug now — two sources with the same title (an annual report, 2024 and 2025) need distinct names before any reader runs — and check that no file anywhere in the vault already has it. Check each against the existing source pages for duplicates and against the schema's out-of-scope list (wiki-ingest-pending, *Before you start*, steps 4 and 5) before any reader is dispatched — a reader writes a source page, and an out-of-scope file must not get one unless the person has overridden the rule (wiki-ingest-pending, *Before you start*, step 5). A re-capture of a source that already has a page gets no reader either: the main session updates that page itself (wiki-ingest-pending, *Before you start*, step 4). Then show the list and, for more than three sources, get a yes.
2. **Read and draft in parallel.** Before dispatching, extend the vault lock's lease to cover the wait (`${CLAUDE_PLUGIN_ROOT}/skills/wiki-setup/references/locking.md`, *Holding it*): the readers can't renew it. Where sub-agents are available, one source each: read the source, draft its source page under the slug you assigned — in the folder schema §3 assigns, which the reader works out after reading, since only then are `published:` and the subject known — and return the path it wrote and a structured touch list (entities, concepts, claims, contradictions, open questions). The `wiki-reader` agent is built for this and already has the write limits baked in; without it, give each sub-agent the schema and the source-page template and tell it explicitly not to touch any other file.

   **Waves of about five**, in order. A wave takes a few minutes, so the person hears from you often (*Showing progress*, below), and the cap can stop the batch cleanly between waves: stop dispatching once the merged touch lists reach it — except within a large source, whose waves all run once its first is dispatched (`large-sources.md`). A wave already drafted is propagated in full, even past the cap — an item held back must never be left with a drafted source page, which would read as an interrupted ingest. A **pass** is one run up to the cap: typically five to ten items, fewer while most items still create pages.

   **Make sure the readers can reach what they read.** They work with plain file tools. Where those see the vault — Claude Code, or a Cowork session working in the folder itself — give them vault paths and let each write under the sources folder. Where they don't — Cowork with the vault on the person's computer, where the session's own file tools work in its workspace and the vault is reached only through the computer link — copy (stage) into the workspace, for each wave: its sources and the images they embed, `_meta/schema.md`, `_meta/templates/source.md`, `index.md` and a list of every `.md` file name in the vault, `raw/` included (one `find` on the computer). Give each reader those copies, the vault path each copy stands for, any `origin:` and git date from an import record, and a draft folder in the session's own outputs folder — not the vault's `outputs/`. At each source's propagation turn, re-run the subject vote if the reader left the subject to you, set its `subject:` line, and write the draft into the vault at its placement. Never hand a reader a vault path it can't open: it fails quietly, or a general-purpose agent without the reader's write limits gets used instead.
3. **Merge the touch lists yourself.** Deduplicate across sources — the same concept will arrive under three names. Decide the canonical name once, here, before any page gets created, and rewrite each drafted source page's `## Entities and concepts` to the canonical names — otherwise the closing step later skips a synonym as a forward link.
4. **Propagate serially**, source by source, oldest first, following `propagation.md`. Later sources then correctly show up as updating or contradicting earlier ones, which is the behaviour you want. In a vault with subjects, re-run *Assigning a subject* (`${CLAUDE_PLUGIN_ROOT}/skills/wiki-setup/references/grouping.md`) at each source's turn: the reader decided before the earlier sources' pages existed. Report a different answer; don't move the file — lint proposes it (check 9).

   Serial means the edits happen in order, not that every page costs its own round trip: read the pass's pages in one command and write them back in one (`propagation.md`, *Working sensibly*).

   **One closing search for the pass, not one per source.** Once the pass's last source is propagated, close all of their lists in one go (`propagation.md`, *Close the list*): the lists themselves and the gaps stay per source, but the backlink search over the vault runs once for every slug in the pass. **No item leaves the inbox until that check has passed** — the moves in wiki-ingest-pending's Step 5 come after it, so a pass interrupted before it still looks interrupted, and the next run finishes it.

   **Read `index.md` once per pass as well.** Whether a page already exists is answered by the name search plus the running list of pages this run has created (`propagation.md`, *Build the touch list first*); the index itself is rebuilt once, in step 5. `_meta/schema.md` is different — re-read it at the start of each pass: it is one file, and it is what the pass is judged against.
5. **One index rebuild per pass, one log entry per batch** — neither per source. The rebuild belongs with the pass's closing check and its inbox moves, so the index and the vault match again at the end of every pass. The log entry names every source and the page counts:

```markdown
## [2026-09-20] ingest | batch of 7 (Q3 competitor filings)
- sources: [[acme-q3]], [[globex-q3]], ... (7 pages in wiki/sources/)
- new: [[pricing-pressure]], [[channel-strategy]] (+3 entities)
- updated: 14 pages, [[overview]], [[index]]
- flagged: 2 contradictions — see [[pricing-pressure]]
```

6. **Report, then offer a lint.** After a batch of more than about five sources, a lint pass almost always finds duplicate concepts and thin pages worth merging.

## Showing progress

A long run is silent while readers work, and the person can't tell a slow run from a stuck one. Keep them informed in a fixed rhythm — for every batch, and for anything else that runs a long time: a folder import, a backlog drain, a maintain run, lint on a large vault, a grouping move.

- **A plan at the start:** how many items, in how many passes, in what order, and roughly how long — *"380 items, about 38 passes of ten, starting with architecture; several minutes a pass. I'll report after each."*
- **One line before each long step:** what is about to happen and how long it takes — *"Reading the next five in parallel, about four minutes."* Expected silence is fine; unexplained silence isn't.
- **A tally after each pass, always in the same shape:** *"Pass 2 of 38 · 22 of 380 ingested · 358 pending · +9 pages · 1 contradiction · 18 min so far."* Then the two or three things worth knowing from that pass, if any.
- **A task list, where the session offers one:** one task per pass, ticked off as each finishes, so progress shows without scrolling back.
- **The same counts in the lock's progress lines** (`${CLAUDE_PLUGIN_ROOT}/skills/wiki-setup/references/locking.md`): `renew <token> "ingest 22/380 — propagating [[transformers]]"`. Anyone can open `_meta/wiki-lock.md` to see where the run is, and wiki-status shows the same line.

- **A line for every file that appears or moves**, as it happens, whatever the skill:

  ```
  + wiki/sources/attention-is-all-you-need.md
  + wiki/concepts/self-attention.md
  → raw/inbox/2026-09-20-attention.pdf → raw/assets/2026-09-20-attention.pdf
  ```

  `+` for a file created — a captured file, a source page, a new entity, concept or note page, a report, a digest — and `→` for a file moved, from and to. **Only files in the vault:** a staged copy or a draft in the session's own workspace gets no line; its vault copy gets one when it is written at its placement. Where a command prints its own line per file — the folder import — that output is the list and isn't repeated. `_meta/wiki-lock.md` and an import record get none. Pages that were only *updated* don't get a line: the report and the log entry name them. Past about twenty lines in one step — a folder import, a grouping move — print the first few and then the count, and leave the full list where it already lives: the import record, `_meta/moves/`, the log entry.

Unattended, the plan, the tallies and the file lines go into the run's report or digest instead — grouped, with counts.

## Without sub-agents

Do it serially, and keep it short. One run takes about eight items at most — or one large source, on its own (`large-sources.md`) — however many were approved — past that, quality slides as context fills. Offer to split the rest across sessions rather than degrading quietly; unattended, leave them pending and say so.

## Quality guards for every batch

- **Same-name check** before every page creation, including aliases and near-synonyms.
- **No new pages below the promotion bar.** Batches inflate page counts fast; hold the line.
- **Cap it.** A batch that would create more than ~20 new pages — entity, concept and other named pages; source pages don't count — stops there (a wave already drafted is finished — step 2), and so does one with more than about eight re-captures, each propagated from a comparison of the old and new copy: ingest the items that fit, oldest first, and leave the rest pending. With the person present, offer the rest after the report, as a new pass — not as a question in the middle of one, while the lock is held. **A large source is one item and is never cut in half** (`large-sources.md`, *In a batch, and unattended*): it takes its place in the order like any item, is checked against the cap when its turn comes, and once started is finished in the same run.
- **Keep the person's review loop alive.** Even in batch mode, report a changelog they can scan in thirty seconds, and name the two or three most interesting things the batch turned up. A batch ingest that produces no surprises usually means nothing was read carefully.
