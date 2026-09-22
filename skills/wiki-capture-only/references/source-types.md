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
- **Very long page** (documentation, a book chapter online) — file it whole. Splitting happens at ingest, not capture.
- **Multi-page article** — fetch each part, concatenate in order with `---` separators and a note of each part's URL.
- **Video or podcast page** — capture the description and any transcript link; if there's a transcript, capture that as the real source and note the media URL.

## PDFs

Copy the file itself into `raw/inbox/` — the PDF is the source, not your transcription of it. Write a sidecar `.md` with the provenance block plus:

```markdown
file: 2026-09-20-attention.pdf
pages: 15
```

For scanned PDFs with no text layer, note it: `ocr_needed: true`. Ingest will read pages as images.

For books: capture one file per chapter where possible, or note chapter ranges in the sidecar so ingest can work through it incrementally. A 400-page book ingested as one "source" produces a useless page.

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

Oldest first, one block per message, sender and timestamp preserved. Strip signatures, legal footers and quoted reply chains that repeat earlier messages. Whether the thread belongs at all was settled by the scope check in wiki-capture-only's step 2 — a private thread with another person is out of scope unless the owner overrides. Inside an in-scope thread, credentials and account numbers stay in the original and out of the capture, per wiki-capture-only's fidelity rules.

## Data files (CSV, XLSX, JSON)

Copy the file into `raw/inbox/`. Write a stub describing: what the dataset is, where it came from, row and column counts, column meanings, the date range covered, and known caveats. Ingest works from the stub plus the file; queries that need numbers read the file directly.

## Their own notes, journal entries, voice memos

File verbatim. Don't clean up grammar, don't reorder. In a personal wiki these are the highest-value sources in the vault, and their rough edges carry information. Voice memos: transcribe, keep the transcription verbatim, note that it's a transcription.

## Books the person is reading

The fastest sustainable loop: capture one chapter's notes at a time (their highlights, or a summary they dictate), ingest, repeat. The wiki then grows alongside the reading, and spoilers stay bounded — note the chapter on every claim so the wiki can be browsed mid-book.

## Repeat captures of the same source

A source that changes (a wiki page, a doc, a dashboard export, a README) gets a new dated file, not an overwrite. `raw/` is append-only. At ingest it updates the existing source page rather than getting its own: `raw:` moves to the new file, the old one goes on `raw_previous:`, and the page says what changed — that diff is often the most interesting thing in the vault.
