# Connection types

Six kinds of finding. For each: how to find it, what evidence it needs before it can be proposed, what to propose, and what it is not. Every finding must also pass the gate in `SKILL.md` (a missing link has its own shorter one) — above all, both halves are source-backed lines you can quote, and the step from them to the connection needs no fact the vault does not hold.

---

## 1. Bridge

**Find:** two pages whose lines, set side by side, yield a consequence neither states — the same mechanism described twice, the same term in different senses, one page's open question answered by the other. Usually they sit in different subjects (different tags, no shared sources, no link between them); inside one subject, only when neither page already draws the consequence. Start from the index: two one-liners that rhyme across subjects are the cheapest signal. Shared vocabulary in page bodies is the next.

**Evidence required:** a source-backed line on each page that carries its half. The bridge is the observation that the two lines are about the same thing; neither line may be an inference, an interpretation, or your paraphrase of general knowledge.

**Propose:** a synthesis note stating the connection in one sentence, quoting or citing each half, marking the connecting step as *(inference)*, and saying what it changes — a question the vault can now answer, or a line the overview should gain. Link it from both pages.

**Not this:** two pages that simply share a topic word. Every page about marketing mentions customers; that is not a bridge.

## 2. Answerable question

**Find:** every open question — `## Open questions` in `overview.md`, and the same section on individual pages. For each, ask whether two or more existing pages together answer it, even though no single page does.

**Evidence required:** the answer is assembled entirely from cited lines. If answering needs a fact no page holds, it is a gap, not an answer — leave it open and hand it to wiki-gaps, naming the missing fact.

**Propose:** a note in the shape wiki-query files — answer up front, reasoning, what the vault still can't say — and, where the question was asked, keep the question and mark it "— answered: [[note]]".

**Not this:** a partial answer dressed as a full one. "The vault now answers half of this" is a legitimate finding; say it exactly that way, leave the question open, and mark it "— partly answered: [[note]]".

## 3. Convergence

**Find:** a claim on a concept or entity page that cites one source, where a second source page states the same claim.

**Evidence required:**

- **Exact support.** The second source says the same thing — same quantity, same direction, same scope. A similar claim, a weaker one, or one about a different population is not corroboration; at most it is a bridge.
- **Independence, from the metadata.** Different `author:`, a different publisher or `url:` domain, and neither source page cites or summarises the other. Two clips of one article, or a report and the press release about it, are one source.

**Propose:** adding the second citation beside the existing claim, and — named as a separate part of the proposal — revisiting the page's `status:` if two independent sources now carry what one did. These are the only edits wiki-dream-ingest makes to an existing claim.

**Not this:** agreement that exists because one source copied the other. Check who cites whom before calling it convergence.

## 4. Missing link

**Find:** a page that discusses another page's subject — by name, alias or clear description — and does not link to it. Lint does not catch these: neither page is an orphan, and no link is broken.

**Evidence required:** the passage on the first page that discusses the second's subject, passing the shorter missing-link gate in `SKILL.md`.

**Propose:** a wikilink at that passage. Nothing else on the page changes. All the missing links of a pass are one finding, listed as a table (page | passage | target), and may be approved as a batch.

**Not this:** two pages that are the *same* subject under different names — that is a duplicate, and merging it is lint check 3's job. Nor a link for its own sake: if the only connection is a shared common word, the link adds noise to the graph.

## 5. Pattern

**Find:** only when the vault has a `patterns.md`. A loop earns a place on it at the third source that shows it; before that it lives as a line on the page it came up on. So look for loops already mentioned on one or two pages, and check the sources ingested since for a third sighting.

**Evidence required:** three source pages, each showing the loop in its own terms on a separate occasion. Two clips or copies of one item count once; three journal entries by the same person are three sightings. This is the same bar ingest applies. Two sightings stay where they are.

**Propose:** a line under `## Observed` in `patterns.md`, with all three sources linked. Keep the wording at the level the sources state it. A pattern about a person's habits is recorded as written, never interpreted.

**Not this:** your own reading of someone's behaviour. `patterns.md` records what sources show; interpretation goes under its `## Interpretation` heading, marked as inference — and interpretation is never a half of a later finding.

## 6. Productive tension

**Find:** two positions that pull against each other without being factually incompatible — the same phrase treated as a goal on one page and forbidden on another, a strategy that one source's evidence quietly undercuts, two frameworks that cannot both be the primary lens.

**Evidence required:** both positions cited, and a clear statement of why this is tension rather than contradiction: they can both be true, and they still cannot both be followed.

**Propose:** a short note naming the tension, both sides cited, and the question it raises. Do not resolve it; the value is in making it visible.

**Not this:** a contradiction — two claims about the same fact that cannot both be true, such as two sources reporting different numbers for the same thing. Those belong to lint check 5, with the schema's contradiction callout on both pages. List them under *Handed elsewhere* rather than dressing them up as insight.
