# Source types: detailed handling

## Web articles

Fetch the page, then convert to markdown with this shape:

```markdown
---
{provenance block}
---

# Title

*By Author · Published 2026-04-02 · https://...*

{body}
```

Keep: headings, lists, tables, block quotes, figure captions, code blocks, footnotes.
Drop: navigation, related-article rails, subscribe boxes, cookie banners, social buttons, comment threads, tracking junk in links.

Common failure modes and what to do:

- **Paywall or login wall** — say so. Offer: they paste the text, they print to PDF and drop it in `raw/inbox/`, or they clip it with the Obsidian Web Clipper from their logged-in browser.
- **JS-rendered page** returning near-empty text — same options; don't file the empty shell.
- **Very long page** (documentation, a book chapter online) — file it whole. Ingest reads a large source in sections and ingests it in one pass (`${CLAUDE_PLUGIN_ROOT}/skills/wiki-ingest-pending/references/large-sources.md`); capture never splits it.
- **Multi-page article** — fetch each part, concatenate in order with `---` separators and a note of each part's URL.
- **Video or podcast page** — capture the description and any transcript link; if there's a transcript, capture that as the real source and note the media URL.

## PDFs

Copy the file itself into `raw/inbox/` — the PDF is the source, not your transcription of it. Write a sidecar `.md` with the provenance block plus:

```markdown
file: 2026-09-20-attention.pdf
pages: 15
```

For scanned PDFs with no text layer, note it: `ocr_needed: true`. Ingest will read pages as images.

For books: file them whole, with the page count in the sidecar. Ingest reads a large source by its own chapters and makes one source page for it, with its claims grouped by chapter (`${CLAUDE_PLUGIN_ROOT}/skills/wiki-ingest-pending/references/large-sources.md`); capture never splits it.

## Transcripts (podcasts, meetings, interviews, videos)

Preserve speaker labels and, where present, timestamps — they become precise citations later (`[[episode-42]] at 14:20`). Normalise the format if it's noisy, but don't rewrite words:

```markdown
**[00:14:20] Guest:** ...
**[00:15:02] Host:** ...
```

Add to the provenance block: `participants:`, `duration:`, `recorded:`. For meetings, list attendees and the meeting's purpose — a transcript without that context is nearly unusable in six months.

## Images, screenshots, figures, diagrams

1. Copy the image into `raw/inbox/`. Ingest moves it to `raw/assets/`; capture doesn't file it there directly.
2. Write a sidecar of the same name stem beside it in `raw/inbox/` that embeds it and describes it:

```markdown
---
{provenance block, source_type: image}
file: 2026-09-20-pricing-chart.png
---

![[2026-09-20-pricing-chart.png]]   <!-- resolves by filename, wherever the image ends up -->

**What it shows:** {one or two sentences on what it depicts — no transcribed text or figures; those go on the source page}
```

The description matters: text search can't see inside a PNG, and the description is what makes the image findable and linkable. Note that reading text and markdown containing images is a two-pass job — the text first, then the images opened separately.

## Email and chat threads

Oldest first, one block per message, sender and timestamp preserved. Strip signatures, legal footers and quoted reply chains that repeat earlier messages. Whether the thread belongs at all was settled by the scope check in wiki-capture-only's step 2, against schema §1's list — a private thread is out of scope only where that list names it (private messages, say), and even then the owner can have it filed anyway. A password, key or account number inside a thread follows wiki-capture-only's fidelity rules (*Secrets inside a document*): kept out where §1's list names credentials, otherwise filed as it is, after a one-line warning.

## Data files (CSV, XLSX, JSON)

Copy the file into `raw/inbox/`. Write a stub describing: what the dataset is, where it came from, row and column counts, column meanings, the date range covered, and known caveats. Ingest works from the stub plus the file; queries that need numbers read the file directly.

## Their own notes, journal entries, voice memos

File verbatim. Don't clean up grammar, don't reorder. In a personal wiki these are the highest-value sources in the vault, and their rough edges carry information. Voice memos: transcribe, keep the transcription verbatim, note that it's a transcription.

## Books the person is reading

The fastest sustainable loop: capture one chapter's notes at a time (their highlights, or a summary they dictate), ingest, repeat. The wiki then grows alongside the reading, and spoilers stay bounded — note the chapter on every claim so the wiki can be browsed mid-book.

## Exports — many items in one file

A file that holds many independent items — a Kindle `My Clippings.txt`, a Readwise or Instapaper export, an `.mbox`, a chat or notes app's export, one markdown file of unrelated notes — is **split into one capture per item**, never filed as one source: a question about one book's highlights should reach that book's page, not a page about the export. A single document with chapters is not an export, however long — that is a large source, read in sections (`${CLAUDE_PLUGIN_ROOT}/skills/wiki-ingest-pending/references/large-sources.md`). A folder of files is an import (`folder-import.md`).

1. **Say what it holds.** The item is what someone would cite: a book's highlights (not each highlight), an email thread (not each message), a note. Count them — *"212 highlights from 14 books: 14 items"* — and past about twenty, say how big the job is and ask on a card, as `folder-import.md` does in its section 2 (split everything, or chosen parts; ingest now or later). Unattended, split everything: splitting decides nothing.
2. **One file per item in `raw/inbox/`**, named `<date>-<item slug>.md` under a stem no file in `raw/` has, holding the item's content verbatim — messages oldest first, highlights in the order the export gives them — with what the export's format wraps around it (JSON keys, separators, repeated headers) dropped. Its provenance block: `title:`, `author:`, `published:` — the item's own date where it has one, never the export's — and `export: <the export's file name> · <item key>`, where the key is what names the same item in a later export: book title and author, thread subject and first message id, note id or title. Each item then goes through step 2's scope test on its own: an `.mbox` can hold one invoice among forty threads.
3. **A later export of the same kind** repeats most of what the last one held. Compare each item with the source page whose `export:` carries its key, by the text of that page's current `raw:` copy: the same → no new file; changed → a new file, which ingest takes as a re-capture of that page; no page → a new item.
4. **The export itself is kept whole**, as the record of what the items were cut from: splitting writes new files and never edits, trims or renames the original. It waits in `raw/inbox/` with its items, and ingest moves it out like any other source — a text export to `raw/`, a binary one (a `.zip`) to `raw/assets/` with its sidecar in `raw/`. Ingest gives it one short source page — `items: <n>` in its frontmatter, what the export is and when it was made, no key claims, `## Entities and concepts` → `none` — and each item's page names it (`export:` in frontmatter, and *"cut from [[<export page>]]"* under *How it sits with the rest of the wiki*). A later export of the same kind is a re-capture of that page: its Version history line says how many items were new, changed and the same. An export whose items already name it is never split again.

Log one entry for the split — `capture | <export> — split into <n> items` — never one per item.

## Repeat captures of the same source

A source that changes (a wiki page, a doc, a dashboard export, a README) gets a new dated file, not an overwrite. `raw/` is append-only. At ingest it updates the existing source page rather than getting its own: `raw:` moves to the new file, the old one goes on `raw_previous:` (which keeps the last ten; every capture also gets its line under `## Version history`), and the page says what changed — that diff is often the most interesting thing in the vault.
