# Large sources

A source past schema §10's **Read in sections past** line (~15,000 words if it has none) — a long plan, a book-length report, a log of hundreds of entries — is too big to read in one go and still leave room to propagate what it says. It is **read in sections and ingested in one pass**: one run, one source page, one log entry, and the file leaves the inbox when the run ends. Nobody runs a second ingest for it, and no run skips it as "needing a pass of its own".

Measure every item at *Pick the items*: `wc -w` on the markdown, or the page count on a binary's sidecar (about 400 words a page). Say which items are large in the list the person sees.

## 1 — Map it

Read its structure, not its text: the headings with their line numbers (`grep -n '^#' <file>`), or a PDF's table of contents and page count. Cut it into **sections of about 5,000–8,000 words along its own headings** — a heading too big for one section is cut again at its next level down; a stretch with no headings is cut at paragraph breaks. Give each section a short label from its heading (`§Phase 2`, `§2025-03 rulings`), and keep the map: label, line or page range, word count.

Say the plan before reading: *"The advisor plan is 68,000 words — reading it in 11 sections, 3 waves, about 15 minutes, then one source page and one round of updates."* Reading writes nothing into the vault; where this run already holds the vault lock, renew it before each wave — or each section, reading serially — for at most 30 minutes at a time (`${CLAUDE_PLUGIN_ROOT}/skills/wiki-setup/references/locking.md`, *Holding it*).

## 2 — Read every section, into extracts

**Every section is read in full.** Sections change how much is read at once, never how much is read.

- **With sub-agents** — one `wiki-reader` per section, in waves of about five, each in *section mode* (`${CLAUDE_PLUGIN_ROOT}/agents/wiki-reader.md`): it is given the file, its section's range, the whole map so it knows where it sits, the slug, the schema, the list of every page name, and a draft folder outside the vault, and it writes one **section extract** and returns its touch list. Once the first wave is dispatched, every wave runs: the batch cap never stops a large source between its sections.
- **Without** — read the sections yourself, one at a time, and write each one's extract to the draft folder before starting the next. What you propagate from is then on disk, not in a context that has been filling for an hour.

A section extract holds: the section's label and range; its key claims, each quotable to the section; the entities, concepts and other named pages it touches, each with what it adds and suggested claim lines ending `— [[<slug>]], §<label>`; contradictions with what the wiki already says; open questions; and figures, dates and definitions worth keeping exactly. Nothing else — it is working material, not a page.

The draft folder is outside the vault — the session's workspace, or a temporary folder — so nothing half-made ever lands in the wiki.

## 3 — One source page

Write the source page from the extracts, as any source page (`references/page-anatomy.md`), with `sections: <n>` in its frontmatter: the summary is written from the whole document, never from the first section; **key claims are grouped by section**, under the section labels; and `## Entities and concepts` is one list, merged across the sections — one line per page, with what the whole source adds to it. Merge the touch lists the way a batch merges its sources' lists (`references/batch-ingest.md`, step 3): the same concept arrives under different names from different sections.

A source page read in sections may run past §10's Split past length: it is the record of one document, and it is never split. It keeps its claims terse — the detail goes to the pages they belong on.

## 4 — Propagate once, page by page

Propagate as for any source (`references/propagation.md`), with one difference: **each page is edited once**, with everything this source adds to it from every section, not once per section. A claim carries its section in its citation — `— [[advisor-skills-plan]], §Phase 2` — the way a transcript's claim carries its timestamp, so a reader can open the right part of a long document. Contradictions within the source itself — an early section superseded by a later one — are recorded on the source page as the document's own revision, not as two sources disagreeing.

The promotion bar holds as for any source: a long document mentions many things once, and a single mention is still a line on the nearest page, not a page of its own.

## 5 — Close and finish

The closing check runs over the merged list (`references/propagation.md`, *Close the list*); then Step 5 moves the file out of the inbox, rebuilds the index and logs one entry: `## [date] ingest | <title> (read in 11 sections)` — or, inside a batch, a line in the batch's entry: `- read in sections: [[advisor-skills-plan]] (11)`.

**A re-capture of a large source** is diffed as any re-capture is (wiki-ingest-pending, *Before you start*, step 4). Where the diff is most of the file, read the changed sections by this file's map rather than the whole document, in the same one pass.

## In a batch, and unattended

- **A large source is one item, in its place in the order** — oldest publication date first, like any other. The batch cap (`references/batch-ingest.md`, *Cap it*) is checked when its turn comes, never in the middle: once started, it is finished in the same run, even past the cap. If the cap is reached before its turn, it stays pending whole — and, being the oldest item left, it comes first in the next run. Say so: *"The advisor plan (68,000 words) goes first in the next run."*
- **wiki-maintain runs it like any other item**, unattended. It is never left out as needing a pass of its own.
- **Without sub-agents**, a large source takes a run to itself: when its turn comes after other items in the same run, it waits for the next run, where it is first — never alongside the ~eight ordinary items a run would otherwise take.
- **Interrupted anyway** — the session ended mid-run. Before step 3 nothing is in the vault, so the next run starts it again from the map. After step 3 its source page exists while the file is still in the inbox: an interrupted ingest (wiki-ingest-pending, *Before you start*, step 4), and the next run finishes it from that page — its key claims by section and its `## Entities and concepts` list say what each page should get, the pages that already cite it are done, and a section is re-read only where the exact wording is needed. Extracts outside the vault don't survive a session; the source page does.
