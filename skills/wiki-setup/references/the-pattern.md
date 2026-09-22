# The pattern, and why it works

## The short version

Most LLM + documents setups are retrieval: you dump files somewhere, the model finds relevant chunks at question time, and writes an answer. Nothing accumulates. The tenth question re-does the work of the first.

An LLM wiki inverts that. The model reads each source **once**, at the time you add it, and folds what it learned into a persistent set of interlinked markdown pages. Cross-references are already made. Contradictions are already flagged. The synthesis already reflects everything read so far. Questions get answered from compiled knowledge, not re-derived from raw text.

The knowledge base is a compounding artifact. Every source and every good question makes it richer.

## Three layers

| Layer | Who owns it | Rule |
|---|---|---|
| `raw/` — the sources | the human | immutable; the ground truth every claim traces back to |
| `wiki/` — the pages | Claude | created, updated and cross-linked by the agent; nothing is deleted without the human's approval |
| `_meta/schema.md` — the conventions | both, co-evolved | the operating manual that makes the agent a maintainer, not a chatbot |

## Three operations

- **Ingest** — a new source arrives; the agent reads it, writes a summary page, and propagates what changed across every affected page. One source typically touches 5–15 pages.
- **Query** — the human asks; the agent reads the index, opens the relevant pages, answers with citations, and files good answers back as new pages so explorations compound too.
- **Lint** — periodically, the agent audits its own work: contradictions, stale claims, orphans, missing pages, gaps worth researching.

## And one this plugin adds

- **Consolidate** — the three operations keep the wiki correct; none of them asks what it *adds up to*. Ingest connects a new source to existing pages, but never connects two old pages to each other. `wiki-dream` does that: it reads across what is already filed for bridges between subjects, questions the vault can now answer, sources that agree independently, pages that should link, and proposes each — as a cited, inference-marked note, a link or an added citation — for the human to approve. Like REM sleep, it consolidates what happened; it never invents.

## The division of labour

The hard part of a knowledge base was never the reading or the thinking — it was the bookkeeping. Updating cross-references, keeping summaries current, noticing that a new paper undercuts a claim made on page 34. Humans abandon wikis because maintenance grows faster than value. An agent doesn't get bored, doesn't forget a backlink, and can touch fifteen files in one pass. Maintenance cost goes to roughly zero, so the wiki stays alive.

That leaves the human with the part that was always theirs: choosing what to read, asking sharp questions, and deciding what it means.

## Design consequences worth remembering

- **Plain markdown, no database.** Portable forever, diffable, greppable, editable by hand, renderable by any tool. Git gives you version history for free.
- **The index beats embeddings at this scale.** A catalog file with one line per page is enough retrieval machinery for a few hundred pages. Add real search only when reading the index stops working.
- **Names are the address space.** `[[wikilinks]]` resolve by filename, so filenames must be unique and stable across the vault.
- **Citations are load-bearing.** A page that can't be traced to `raw/` is a rumour. The agent's judgement is welcome, but it gets labelled as inference.
- **Contradiction is information.** When a new source disagrees with an old one, the wiki records the disagreement rather than smoothing it away. That's the part a chat transcript can never do for you.
